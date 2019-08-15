//
//  NewFriendTableViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 6/25/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class NewFriendTableViewController: UITableViewController {

    let cellID = "friendCell"
    private var profile: Profile?
    var accounts = [SAccount]()
    var delegate: CardViewDelegate!
    
    // Fills accounts when profile is set
    func setProfile(profile: Profile) {
        self.profile = profile
        accounts = profile.getAccounts()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        tableView.register(NewFriendTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        tableView.dataSource = self
        tableView.delegate = self
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewFriendTableViewCell
        cell.account = accounts[indexPath.row]
        cell.setupViews()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }


    var wasScrollingAtTop = false
    var isDragging = false
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= 0 || delegate.totalOffset() > delegate.maxOffset()) && isDragging {
            wasScrollingAtTop = true
            delegate.updateCardPosition(offset: -scrollView.contentOffset.y)
            // maxOffset is actually min offset since it's negative
            if delegate.totalOffset() > delegate.maxOffset() {
                scrollView.contentOffset.y = 0
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDragging = false
        if wasScrollingAtTop {
            delegate.releaseCard(velocity: velocity.y)
            wasScrollingAtTop = false
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let sna = accounts[indexPath.row] as? SSnapchat {
            if let url = URL(string: "snapchat://add/" + sna.data) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        if let ins = accounts[indexPath.row] as? SInstagram {
            if let url = URL(string: "instagram://user?username=" + ins.data) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }

    }
    
}
