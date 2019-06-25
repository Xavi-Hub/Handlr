//
//  ViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 10/20/18.
//  Copyright © 2018 Xavi Anderhub. All rights reserved.
//

import UIKit
import AVFoundation

protocol Account: Codable {
    var data: String {get set}
}

struct Snapchat: Account {
    var data: String
}

struct Instagram: Account {
    var data: String
}

struct Facebook: Account {
    var data: String
}

struct PhoneNumber: Account {
    var data: String
}

class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Me", style: .plain, target: self, action: #selector(showMeView))

        startCapturing()
        
    }
    
    @objc func showMeView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        navigationController?.pushViewController(MeCollectionViewController(collectionViewLayout: layout), animated: true)
    }
    
    func startCapturing() {
        let session = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: .video)!
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch let error {
            print(error)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.videoGravity = .resizeAspectFill
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
                
        session.startRunning()
    }

    var displayingData = false
    var scannedAccounts: [Account] = []
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if displayingData {return}
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    displayingData = true
                    let me = getMeFromString(string: object.stringValue ?? "")
                    var alertString = ""
                    var alert = UIAlertController()
                    if let me = me {
                        if let ins = me.ins {
                            for anIns in ins {
                                alertString.append(contentsOf: "Instagram: " + anIns + "\n")
                                scannedAccounts.append(Instagram(data: anIns))
                            }
                        }
                        if let sna = me.sna {
                            for aSna in sna {
                                alertString.append(contentsOf: "Snapchat: " + aSna + "\n")
                                scannedAccounts.append(Snapchat(data: aSna))
                            }
                        }
                        if let pho = me.pho {
                            for aPho in pho {
                                alertString.append(contentsOf: "Phone: " + aPho + "\n")
                                scannedAccounts.append(PhoneNumber(data: aPho))
                            }
                        }
                        alert = UIAlertController(title: "QR Code", message: alertString, preferredStyle: .alert)
                    } else {
                        alert = UIAlertController(title: "QR Code", message: "Not Recognized", preferredStyle: .alert)
                    }
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    displayingData = false
                }
            }
        }
    }

    func getMeFromString(string: String) -> Profile? {
        do {
            let me = try JSONDecoder().decode(Profile.self, from: string.data(using: .utf8)!)
            return me
        } catch {
            print(error)
            return nil
        }
        
    }
    
}
