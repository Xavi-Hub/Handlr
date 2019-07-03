//
//  MyProfileViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    var profileData: ProfileData!
    var collectionView: MeCollectionViewController!
    let tableView = UITableView()
    var accounts = [Account]()
    let cellID = "meCell"
    
    init(profileData: ProfileData) {
        self.profileData = profileData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    
    }

    
    func setProfileData(profileData: ProfileData) {
        self.profileData = profileData
        
    }
    
    func setupViews() {
        setProfileData(profileData: profileData)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
                
        
        view.addSubview(meView)
        view.addSubview(imageView)
        view.addSubview(tableView)
        
        meView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        meView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9).isActive = true
        meView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        meView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        meView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        setEditing(isEditing, animated: true)
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            meView.isHidden = false
            imageView.isHidden = true
            tableView.isHidden = false
        } else {
            meView.isHidden = true
            imageView.isHidden = false
            imageView.image = profileData.profile!.getQRImage()
            tableView.isHidden = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData.profile!.getAccounts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MeTableViewCell
        return cell
    }
    

}
