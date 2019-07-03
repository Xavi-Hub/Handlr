//
//  Profile.swift
//  Handlr
//
//  Created by Xavi Anderhub on 7/1/19.
//  Copyright © 2019 Xavi Anderhub. All rights reserved.
//

import Foundation
import UIKit

struct Profile: Codable {
    let name: String
    let ins: [String]
    let sna: [String]
    let pho: [String]
    
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
