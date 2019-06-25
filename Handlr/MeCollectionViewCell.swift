//
//  MeCollectionViewCell.swift
//  Handlr
//
//  Created by Xavi Anderhub on 10/22/18.
//  Copyright © 2018 Xavi Anderhub. All rights reserved.
//

import UIKit

class MeCollectionViewCell: UICollectionViewCell {
    
    var me: Profile!
    var collectionView: MeCollectionViewController!
    
    var meView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()
    
    var meTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .red
        return iv
    }()

    var isEditing = false
    
    func setupViews(me: Profile, isEditing: Bool) {
        self.me = me
        setEditing(editing: isEditing)
        
        backgroundColor = .clear
        
        
        addSubview(meView)
        addSubview(imageView)
                
        meView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        meView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.9).isActive = true
        meView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        meView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        meView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
        imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true

        
        

        setEditing(editing: isEditing)
                
        
        
    }
    
    
    func setEditing(editing: Bool) {
        isEditing = editing
        if editing {
            meView.isHidden = false
            imageView.isHidden = true
        } else {
            meView.isHidden = true
            imageView.isHidden = false
            imageView.image = getQRImage()
        }
    }
    
    
    func getQRImage() -> UIImage {
        var jsonData: Data = Data()
        do {
            jsonData = try JSONEncoder().encode(me)
        } catch {print(error)}
        
        /* JSON string should be:
         {"ins":["XaviHub"],"sna":["XaviHub8"],"pho":["214-926-7723"]}
         
         
         */
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(jsonData, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 100, y: 100)
        return UIImage(ciImage: filter!.outputImage!.transformed(by: transform))
    }

    

    
    
    
}
