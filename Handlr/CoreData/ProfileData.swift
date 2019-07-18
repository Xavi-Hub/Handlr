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
                var inss = [Int16:String]()
                var snas = [Int16:String]()
                var phos = [Int16:String]()
                for anAcct in Array(accounts ?? NSSet()) {
                    if let anIns = anAcct as? Instagram {
                        inss[anIns.order] = anIns.data ?? ""
                    }
                    if let aSna = anAcct as? Snapchat {
                        snas[aSna.order] = aSna.data ?? ""
                    }
                    if let aPho = anAcct as? Phone {
                        phos[aPho.order] = aPho.data ?? ""
                    }
                }
                let profile = Profile(name: name ?? "", ins: inss, sna: snas, pho: phos)
                return profile
//                let profile = try JSONDecoder().decode(Profile.self, from: (data ?? "").data(using: .utf8)!)
            }
        }
        
//        set {
//            var jsonData: Data = Data()
//            do {
//                jsonData = try JSONEncoder().encode(newValue)
//                let theString = String(data: jsonData, encoding: .utf8)
//                data = theString
//            } catch {print(error)}
//
//        }
    }

    
}
