//
//  ProfileData.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import UIKit
import CoreData

class ProfileData: NSManagedObject {
    
    var profile: Profile? {
        get {
            do {
                let profile = try JSONDecoder().decode(Profile.self, from: (data ?? "").data(using: .utf8)!)
                return profile
            } catch {
                print(error)
                return nil
            }
        }
        
        set {
            var jsonData: Data = Data()
            do {
                jsonData = try JSONEncoder().encode(newValue)
                let theString = String(data: jsonData, encoding: .utf8)
                data = theString
            } catch {print(error)}
            
        }
    }

    
}
