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
    
    let accountTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let dataField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.returnKeyType = .done
        tf.textColor = .black
        return tf
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        return view
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
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
            accountTypeLabel.text = "Snapchat"
            dataField.placeholder = "Snapchat"
            iconImageView.image = UIImage(named: "snapchat")
        case is Instagram:
            accountTypeLabel.text = "Instagram"
            dataField.placeholder = "Instagram"
            iconImageView.image = UIImage(named: "instagram")
        case is Phone:
            accountTypeLabel.text = "Phone Number"
            dataField.placeholder = "Phone Number"
            iconImageView.image = UIImage(named: "phone")
        default:
            accountTypeLabel.text = ""
        }
        
        dataField.text = account.data
        
        backgroundColor = .white
        
//        addSubview(accountTypeLabel)
        addSubview(iconImageView)
        addSubview(dataField)
        addSubview(dividerLine)
//        accountTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        dataField.translatesAutoresizingMaskIntoConstraints = false
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        
        
//        accountTypeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        accountTypeLabel.rightAnchor.constraint(equalTo: leftAnchor, constant: 100).isActive = true
//        accountTypeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        
        dataField.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 20).isActive = true
        dataField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        dataField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        account.data = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
