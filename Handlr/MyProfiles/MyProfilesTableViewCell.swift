//
//  MyProfilesTableViewCell.swift
//  Handlr
//
//  Created by Xavi Anderhub on 8/21/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class MyProfilesTableViewCell: UITableViewCell {
    
    var profile: ProfileData!
    
    var profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
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
        
        backgroundColor = .clear
        
        profileLabel.text = profile.name ?? ""
        
        addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        
        profileLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        
    }

}
