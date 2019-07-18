//
//  Profile.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import Foundation
import UIKit

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


}
