//
//  ProfileData+CoreDataProperties.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//
//

import Foundation
import CoreData


extension ProfileData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileData> {
        return NSFetchRequest<ProfileData>(entityName: "ProfileData")
    }

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
    
    @NSManaged public var data: String?
    @NSManaged public var isMine: Bool
    @NSManaged public var name: String?

}
