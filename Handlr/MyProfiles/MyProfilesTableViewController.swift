//
//  MyProfilesTableViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 8/21/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class MyProfilesTableViewController: UITableViewController {
    
    var profilesData = [ProfileData]()
    var currentProfile: ProfileData!
    let cellID = "profilesCell"
    var delegate: CardViewDelegate!
    
    init(currentProfile: ProfileData) {
        super.init(nibName: nil, bundle: nil)
        self.currentProfile = currentProfile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.register(MyProfilesTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .white
        
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profilesData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MyProfilesTableViewCell
        cell.profile = profilesData[indexPath.row]
        cell.setupViews()
        return cell
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


}
