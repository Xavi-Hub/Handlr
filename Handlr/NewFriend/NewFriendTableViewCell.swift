//
//  NewFriendTableViewCell.swift
//  Handlr
//
//  Created by Xavi Anderhub on 6/25/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class NewFriendTableViewCell: UITableViewCell {

    var account: Account!
    
    var accountIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "snapchat"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let accountTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    let dataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews() {
        
        switch account {
        case is Snapchat:
            accountIcon.image = UIImage(named: "snapchat")
            accountTypeLabel.text = "Snapchat"
        case is Instagram:
            accountIcon.image = UIImage(named: "instagram")
            accountTypeLabel.text = "Instagram"
        case is PhoneNumber:
            accountIcon.image = UIImage(named: "phone")
            accountTypeLabel.text = "Phone"
        default:
            accountIcon.image = UIImage()
        }
        
        dataLabel.text = account.data
        
        backgroundColor = .white
        
        addSubview(accountIcon)
        addSubview(accountTypeLabel)
        addSubview(dataLabel)
        accountIcon.translatesAutoresizingMaskIntoConstraints = false
        accountTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        accountIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        accountIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 50).isActive = true
        accountIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        accountIcon.widthAnchor.constraint(equalTo: accountIcon.heightAnchor).isActive = true
        
        accountTypeLabel.leftAnchor.constraint(equalTo: accountIcon.rightAnchor, constant: 50).isActive = true
        accountTypeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        accountTypeLabel.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true

        dataLabel.leftAnchor.constraint(equalTo: accountTypeLabel.leftAnchor).isActive = true
        dataLabel.rightAnchor.constraint(equalTo: accountTypeLabel.rightAnchor).isActive = true
        dataLabel.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }

}
