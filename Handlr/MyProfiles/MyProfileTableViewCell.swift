//
//  MyProfileTableViewCell.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var account: Account!
    
    var accountIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "snapchat"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let accountTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    let dataField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = .white
        tf.returnKeyType = .done
        return tf
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
        dataField.delegate = self
        dataField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        switch account {
        case is Snapchat:
            accountIcon.image = UIImage(named: "snapchat")
            accountTypeLabel.text = "Snapchat"
        case is Instagram:
            accountIcon.image = UIImage(named: "instagram")
            accountTypeLabel.text = "Instagram"
        case is Phone:
            accountIcon.image = UIImage(named: "phone")
            accountTypeLabel.text = "Phone"
        default:
            accountIcon.image = UIImage()
        }
        
        dataField.text = account.data
        
        backgroundColor = .clear
        
        addSubview(accountIcon)
        addSubview(accountTypeLabel)
        addSubview(dataField)
        accountIcon.translatesAutoresizingMaskIntoConstraints = false
        accountTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        dataField.translatesAutoresizingMaskIntoConstraints = false
        
        accountIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        accountIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 50).isActive = true
        accountIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        accountIcon.widthAnchor.constraint(equalTo: accountIcon.heightAnchor).isActive = true
        
        accountTypeLabel.leftAnchor.constraint(equalTo: accountIcon.rightAnchor, constant: 50).isActive = true
        accountTypeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        accountTypeLabel.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        dataField.leftAnchor.constraint(equalTo: accountTypeLabel.leftAnchor).isActive = true
        dataField.rightAnchor.constraint(equalTo: accountTypeLabel.rightAnchor).isActive = true
        dataField.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        account.data = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
