//
//  AddAccountTableViewCell.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/16/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class AddAccountTableViewCell: UITableViewCell {
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 67/255, green: 121/255, blue: 238/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "+ Add Account..."
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
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        
    }
    
}
