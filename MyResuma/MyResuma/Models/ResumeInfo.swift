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
    
    //general information
    var name:String! = ""
    var mobile:String?
    var email:String?
    var address:String?
    var careerObjective:String?
    var totalYearOfExp:String?
    
    
    var workExperiences:[WorkExperience]?
    var skills:[Skill]?
    var projectExperiences:[ProjectExperience]?
    var educations:[Education]?
    
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

class WorkExperience:Codable {
    var workID:String = UUID.init().uuidString
    var companyName:String?
    var startYear:String?
    var endYear:String?
    
    func displayYearRange() -> String {
        var result = ""
        if let start = startYear?.trimmingCharacters(in: .whitespaces) {
            result.append("\(start) - ")
            if let end = endYear?.trimmingCharacters(in: .whitespaces), end.count > 0 {
                result.append(end)
            }
            else {
                result.append("present")
            }
        }
        return result
    }
}

class ProjectExperience:Codable {
    var projectID:String = UUID.init().uuidString
    var name:String?
    var teamSize:String?
    var summary:String?
    var techUsed:String?
    var role:String?
}

class Education:Codable {
    var educationID:String = UUID.init().uuidString
    var name:String?
    var level:String?
    var passingYear:String?
    var isPercentage:Bool?
    var score:String?
}

class Skill:Codable {
    var skillID:String = UUID.init().uuidString
    var name:String?
}

