//
//  Profile.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SAccount: Codable {
    var data: String {get set}
    var order: Int16 {get set}
}

struct SSnapchat: SAccount {
    var data: String
    var order: Int16
}

struct SInstagram: SAccount {
    var data: String
    var order: Int16
}

struct SFacebook: SAccount {
    var data: String
    var order: Int16
}

struct SPhoneNumber: SAccount {
    var data: String
    var order: Int16
}


struct Profile: Codable {
    let name: String
    let ins: [Int16:String]
    let sna: [Int16:String]
    let pho: [Int16:String]
    
    func getAccounts() -> [SAccount] {
        var accounts = [SAccount]()
        for ins in ins {
            accounts.append(SInstagram(data: ins.value, order: ins.key))
        }
        for sna in sna {
            accounts.append(SSnapchat(data: sna.value, order: sna.key))
        }
        for pho in pho {
            accounts.append(SPhoneNumber(data: pho.value, order: pho.key))
        }
        return accounts
    }
    
    func getQRImage() -> UIImage {
        var jsonData: Data = Data()
        do {
            jsonData = try JSONEncoder().encode(self)
        } catch {print(error)}
        
        /* JSON string should be:
         {"ins":["XaviHub"],"sna":["XaviHub8"],"pho":["214-926-7723"]}
         
         
         */
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(jsonData, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 100, y: 100)
        return UIImage(ciImage: filter!.outputImage!.transformed(by: transform))
    }
    
    static func getProfileFromString(string: String) -> Profile? {
        do {
            let profile = try JSONDecoder().decode(Profile.self, from: string.data(using: .utf8)!)
            return profile
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func addToDatabase() {
        let request: NSFetchRequest<ProfileData> = NSFetchRequest<ProfileData>(entityName: "ProfileData")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "isMine = %d", false)
        request.predicate = predicate
        let profilesData = try? AppDelegate.viewContext.fetch(request)
        let profileData = NSEntityDescription.insertNewObject(forEntityName: "ProfileData", into: AppDelegate.viewContext) as! ProfileData
        profileData.isMine = false
        profileData.name = name
        profileData.order = Int16(profilesData?.count ?? 0)
        for anIns in ins {
            let insData = NSEntityDescription.insertNewObject(forEntityName: "Instagram", into: AppDelegate.viewContext) as! Instagram
            insData.profileData = profileData
            insData.data = anIns.value
            insData.order = anIns.key
        }
        for aSna in sna {
            let snaData = NSEntityDescription.insertNewObject(forEntityName: "Snapchat", into: AppDelegate.viewContext) as! Snapchat
            snaData.profileData = profileData
            snaData.data = aSna.value
            snaData.order = aSna.key
        }
        for aPho in pho {
            let phoData = NSEntityDescription.insertNewObject(forEntityName: "Phone", into: AppDelegate.viewContext) as! Phone
            phoData.profileData = profileData
            phoData.data = aPho.value
            phoData.order = aPho.key
        }
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print(error)
        }
    }


}
