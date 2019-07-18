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
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
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
        
        backgroundColor = .clear
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        
    }
    
}
