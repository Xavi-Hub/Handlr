//
//  MyProfileViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit
import CoreData


class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var profileData: ProfileData!
    let tableView = UITableView()
    let acctCell = "acctCell"
    let addCell = "addCell"
    
    var accounts = [Account]()
    
    init(profileData: ProfileData) {
        super.init(nibName: nil, bundle: nil)
        self.profileData = profileData
        self.setupAccounts()
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
    
    func setupAccounts() {
        let request: NSFetchRequest<Account> = NSFetchRequest<Account>(entityName: "Account")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "profileData = %@", profileData)
        request.predicate = predicate
        accounts = (try? AppDelegate.viewContext.fetch(request)) ?? []
        
    }
    
    
    func setupViews() {
        tableView.register(MyProfileTableViewCell.self, forCellReuseIdentifier: acctCell)
        tableView.register(AddAccountTableViewCell.self, forCellReuseIdentifier: addCell)
        tableView.backgroundColor = Colors.mainGray
        tableView.delegate = self
        tableView.dataSource = self
        
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
        setupAccounts()
        if editing {
            tableView.reloadData()
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
        // 1 for adding cell
        setupAccounts()
        return (profileData.accounts?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == profileData.accounts?.count ?? 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addCell) as! AddAccountTableViewCell
            cell.setupViews()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: acctCell) as! MyProfileTableViewCell
            cell.account = accounts[indexPath.row]
            cell.setupViews()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == profileData.accounts?.count ?? 0 {
            showActionSheet()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func showActionSheet() {
        let actionSheet = UIAlertController()
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        var newEntity: Account!
        let ins = UIAlertAction(title: "Instagram", style: .default) { (action) in
            newEntity = NSEntityDescription.insertNewObject(forEntityName: "Instagram", into: AppDelegate.viewContext) as! Instagram
            self.setupNewAccount(account: newEntity)
            self.tableView.reloadData()
        }
        let sna = UIAlertAction(title: "Snapchat", style: .default) { (action) in
            newEntity = NSEntityDescription.insertNewObject(forEntityName: "Snapchat", into: AppDelegate.viewContext) as! Snapchat
            self.setupNewAccount(account: newEntity)
            self.tableView.reloadData()
        }
        let pho = UIAlertAction(title: "Phone Number", style: .default) { (action) in
            newEntity = NSEntityDescription.insertNewObject(forEntityName: "Phone", into: AppDelegate.viewContext) as! Phone
            self.setupNewAccount(account: newEntity)
            self.tableView.reloadData()
        }
        
        actionSheet.addAction(ins)
        actionSheet.addAction(sna)
        actionSheet.addAction(pho)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func setupNewAccount(account: Account) {
        account.profileData = self.profileData
        account.order = Int16(self.accounts.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75.0)
    }
    

}
