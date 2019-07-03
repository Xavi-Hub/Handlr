//
//  Profile+CoreDataProperties.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var data: String?
    @NSManaged public var isMine: Bool
    @NSManaged public var name: String?

    let ins: [String] {
        get {
            
        }
    }
    let sna: [String]
    let pho: [String]
    
    func getProfileFromString(string: String) -> Profile? {
        do {
            let profile = try JSONDecoder().decode(Profile.self, from: string.data(using: .utf8)!)
            return profile
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func getAccounts() -> [Account] {
        var accounts = [Account]()
        for ins in ins {
            accounts.append(Instagram(data: ins))
        }
        for sna in sna {
            accounts.append(Snapchat(data: sna))
        }
        for pho in pho {
            accounts.append(PhoneNumber(data: pho))
        }
        return accounts
    }

    
}
