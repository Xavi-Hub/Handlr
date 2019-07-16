//
//  ViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 10/20/18.
//  Copyright © 2018 Xavi Anderhub. All rights reserved.
//

import UIKit
import AVFoundation

protocol CardViewDelegate {
    func updateCardPosition(offset: CGFloat)
    func releaseCard(velocity: CGFloat)
    func totalOffset() -> CGFloat
    func maxOffset() -> CGFloat
}

class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CardViewDelegate, UIGestureRecognizerDelegate {

    var video = AVCaptureVideoPreviewLayer()
    let notificationGenerator = UINotificationFeedbackGenerator()
    let touchView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Me", style: .plain, target: self, action: #selector(showMeView))

        startCapturing()
        setupCard()
        setupTouchView()
        setupTouchRecognizer()
        
    }
    
    func setupTouchRecognizer() {
        let touchRecognizer = UILongPressGestureRecognizer(target:self, action: #selector(dismissCard(gesture:)))
        touchRecognizer.minimumPressDuration = 0
        touchView.addGestureRecognizer(touchRecognizer)
    }
    
    func setupTouchView() {
        view.addSubview(touchView)
        touchView.translatesAutoresizingMaskIntoConstraints = false
        touchView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        touchView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -maxCardHeight   ).isActive = true
        touchView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        touchView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc func showMeView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        navigationController?.pushViewController(MyProfilesPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil), animated: true)
    }
    
    let cardView = NewFriendTableViewController()
    var cardTopConstraint: NSLayoutConstraint!
    let maxCardHeight: CGFloat = 500.0
    func setupCard() {
        
        cardView.view.isHidden = true
        
        cardView.delegate = self
        self.addChild(cardView)
        
        view.addSubview(cardView.view)
        cardView.view.translatesAutoresizingMaskIntoConstraints = false
        cardView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cardView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cardView.view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        cardTopConstraint = cardView.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
        cardTopConstraint.isActive = true
        
        cardView.view.frame = CGRect(x: 0, y: view.frame.height-150, width: view.frame.width, height: view.frame.height)
        cardView.setProfile(profile: Profile(name: "Xavi Anderhub", ins: ["XaviHub18", "OsciHub"], sna: ["XaviHub"], pho: ["214-926-7723"]))
        cardView.view.clipsToBounds = true
        
        
    }
    
    func updateCardPosition(offset: CGFloat) {
        cardTopConstraint.constant += offset
        if cardTopConstraint.constant < -maxCardHeight {
            cardTopConstraint.constant = -maxCardHeight
        }
    }
    
    func releaseCard(velocity: CGFloat) {
        if velocity < -1.0 {
            cardTopConstraint.constant = 0
            displayingData = false
        } else {
            cardTopConstraint.constant = -maxCardHeight
        }
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: velocity, options: [UIView.AnimationOptions.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.cardView.view.isHidden = !self.displayingData
        }
    }
    
    func totalOffset() -> CGFloat {
        return cardTopConstraint.constant
    }
    func maxOffset() -> CGFloat {
        return -maxCardHeight
    }
    
    @objc func dismissCard(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            cardTopConstraint.constant = 0
            displayingData = false
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction], animations: {
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.cardView.view.isHidden = !self.displayingData
            }
        }
    }
    
    func showCard() {
        cardView.view.isHidden = false
        cardTopConstraint.constant = -maxCardHeight
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
    var scannedAccounts: [SAccount] = []
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if displayingData {return}
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    notificationGenerator.notificationOccurred(.success)
                    displayingData = true
                    let me = Profile.getProfileFromString(string: object.stringValue ?? "")
                    var alertString = ""
                    var alert = UIAlertController()
                    if let me = me {
                        for anIns in me.ins {
                            alertString.append(contentsOf: "Instagram: " + anIns + "\n")
                            scannedAccounts.append(SInstagram(data: anIns))
                        }
                        for aSna in me.sna {
                            alertString.append(contentsOf: "Snapchat: " + aSna + "\n")
                            scannedAccounts.append(SSnapchat(data: aSna))
                        }
                        for aPho in me.pho {
                            alertString.append(contentsOf: "Phone: " + aPho + "\n")
                            scannedAccounts.append(SPhoneNumber(data: aPho))
                        }
                        alert = UIAlertController(title: "QR Code", message: alertString, preferredStyle: .alert)
                    } else {
                        alert = UIAlertController(title: "QR Code", message: "Not Recognized", preferredStyle: .alert)
                    }
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    showCard()
                }
            }
        }
    }
    
}

