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
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let acctCell = "acctCell"
    let addCell = "addCell"
    let headerCell = "headerCell"
    var accountHeader = "accountHeader"
    
    var accounts = [[Account]]()
    var inss = [Instagram]()
    var snas = [Snapchat]()
    var phos = [Phone]()
    
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
        return iv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        
    
    }
    
    func setupAccounts() {
        let insRequest: NSFetchRequest<Instagram> = NSFetchRequest<Instagram>(entityName: "Instagram")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        insRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "profileData = %@", profileData)
        insRequest.predicate = predicate
        inss = (try? AppDelegate.viewContext.fetch(insRequest)) ?? []
        let snaRequest: NSFetchRequest<Snapchat> = NSFetchRequest<Snapchat>(entityName: "Snapchat")
        snaRequest.sortDescriptors = [sortDescriptor]
        snaRequest.predicate = predicate
        snas = (try? AppDelegate.viewContext.fetch(snaRequest)) ?? []
        let phoRequest: NSFetchRequest<Phone> = NSFetchRequest<Phone>(entityName: "Phone")
        phoRequest.sortDescriptors = [sortDescriptor]
        phoRequest.predicate = predicate
        phos = (try? AppDelegate.viewContext.fetch(phoRequest)) ?? []

        accounts = [inss, snas, phos]
        
    }
    
    
    func setupViews() {
        tableView.register(MyProfileTableViewCell.self, forCellReuseIdentifier: acctCell)
        tableView.register(AddAccountTableViewCell.self, forCellReuseIdentifier: addCell)
        tableView.register(MyProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: headerCell)
        tableView.register(AccountTypeHeader.self, forHeaderFooterViewReuseIdentifier: accountHeader)
        tableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // +1 for name header
        setupAccounts()
        return accounts.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setupAccounts()
        // -1 because there is an extra header at top for name
        if section == 0 {
            return 0
        }
        // +1 for add account cell
        return accounts[section-1].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= accounts[indexPath.section - 1].count {
            let cell = tableView.dequeueReusableCell(withIdentifier: addCell) as! AddAccountTableViewCell
            cell.setupViews()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: acctCell) as! MyProfileTableViewCell
            // -1 because name header
            cell.account = accounts[indexPath.section-1][indexPath.row]
            cell.setupViews()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // -1 for name header
        if indexPath.row == accounts[indexPath.section-1].count{
            showActionSheet()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCell) as! MyProfileHeaderView
            header.profileData = profileData
            header.setupViews()
            return header
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: accountHeader) as! AccountTypeHeader
            if section == 1 {
                header.accountType = .instagram
            } else if section == 2 {
                header.accountType = .snapchat
            } else if section == 3 {
                header.accountType = .phone
            }
            header.setupViews()
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(50)
        } else {
            return CGFloat(30)
        }
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
    
    

}
