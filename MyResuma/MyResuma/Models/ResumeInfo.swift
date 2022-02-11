//
//  ResumeInfo.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import Foundation
import UIKit


class ResumeInfo: Codable {
    var resumeID:String = UUID.init().uuidString
    var title:String!
    var profileImageData:Data?
    
    func profileImage() -> UIImage {
        if let imageData = self.profileImageData,
           let image = UIImage.init(data: imageData) {
            return image
        }
        else {
            return UIImage.init(named: "ic_default_profile")!
        }
    }
    
    func copy() throws -> ResumeInfo {
        let data = try JSONEncoder().encode(self)
        let copy = try JSONDecoder().decode(ResumeInfo.self, from: data)
        
        copy.resumeID = UUID().uuidString
        
        return copy
    }
}

