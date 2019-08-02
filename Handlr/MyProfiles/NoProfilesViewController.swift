//
//  NoProfilesViewController.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/2/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit

class NoProfilesViewController: UIViewController {
    
    let noProfilesLabel: UILabel = {
        let label = UILabel()
        label.text = "No Profiles"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(noProfilesLabel)
        noProfilesLabel.translatesAutoresizingMaskIntoConstraints = false
        noProfilesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noProfilesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    


}
