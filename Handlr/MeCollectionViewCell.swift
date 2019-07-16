//
//  MeCollectionViewCell.swift
//  Handlr
//
//  Created by Xavi Anderhub on 10/22/18.
//  Copyright © 2018 Xavi Anderhub. All rights reserved.
//

import UIKit

class MeCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    var profile: Profile!
    var collectionView: MeCollectionViewController!
    let tableView = UITableView()
    var accounts = [Account]()
    let cellID = "meCell"
    
    var meView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()
    
    var meTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .red
        return iv
    }()

    var isEditing = false
    
    func setProfile(profile: Profile) {
        self.profile = profile
        
    }
    
    func setupViews(profile: Profile, isEditing: Bool) {
        setProfile(profile: profile)
        setEditing(editing: isEditing)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        backgroundColor = .clear
        
        
        addSubview(meView)
        addSubview(imageView)
        addSubview(tableView)
                
        meView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        meView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.9).isActive = true
        meView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        meView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        meView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
        imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        

        setEditing(editing: isEditing)
                
        
        
    }
    
    
    func setEditing(editing: Bool) {
        isEditing = editing
        if editing {
            meView.isHidden = false
            imageView.isHidden = true
            tableView.isHidden = false
        } else {
            meView.isHidden = true
            imageView.isHidden = false
            imageView.image = profile.getQRImage()
            tableView.isHidden = true
        }
    }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.getAccounts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyProfileTableViewCell
        return cell
    }
    
    
    
}
