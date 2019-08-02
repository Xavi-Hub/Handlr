//
//  MyProfileHeaderView.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/30/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class MyProfileHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {

    var profileData: ProfileData!
    
    var nameField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 36)
        field.textColor = .black
        field.placeholder = "Profile Name"
        return field
    }()
        
    var backView = UIView()
    
    func setupViews() {
        nameField.delegate = self
        nameField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        nameField.text = profileData.name ?? ""
        backgroundColor = .white
        backgroundView = backView
        
        addSubview(nameField)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .white
        nameField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        nameField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        profileData.name = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}
