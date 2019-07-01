//
//  MeViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 10/21/18.
//  Copyright © 2018 Xavi Anderhub. All rights reserved.
//

import UIKit

struct Profile: Codable {
    let ins: [String]
    let sna: [String]
    let pho: [String]
    
    func getAccounts() -> [Account] {
        var accounts = [Account]()
        for ins in ins {
            accounts.append(Instagram(data: ins))
        }
        for sna in sna {
            accounts.append(Snapchat(data: sna))
        }
        for pho in pho {
            accounts.append(PhoneNumber(data: pho))
        }
        return accounts
    }
}

class MeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MeCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
        
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        setupViews()
        
    }
    
    func setupViews() {
        
        collectionView?.backgroundColor = UIColor(red: 61/255, green: 139/255, blue: 191/255, alpha: 1.0)
        
        
    }
        
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        collectionView.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height*0.8)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MeCollectionViewCell
        cell.setupViews(profile: Profile(ins: ["XaviHub18", "OsciHub"], sna: ["XaviHub"], pho: ["214-926-7723"]), isEditing: isEditing)
        return cell
    }
    
    
    
    
}
