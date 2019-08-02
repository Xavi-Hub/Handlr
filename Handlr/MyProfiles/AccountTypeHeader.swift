//
//  AccountTypeHeader.swift
//  Handlr
//
//  Created by Xavi Anderhub on 8/2/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

enum AccountType {
    case instagram
    case snapchat
    case phone
}

class AccountTypeHeader: UITableViewHeaderFooterView {

    var accountType: AccountType!
    var accountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    func setupViews() {
        
        switch accountType {
        case .instagram:
            accountLabel.text = "INSTAGRAM"
        case .snapchat:
            accountLabel.text = "SNAPCHAT"
        case .phone:
            accountLabel.text = "PHONE NUMBER"
        case .none:
            accountLabel.text = ""
        }
        
        addSubview(accountLabel)
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        accountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }

}
