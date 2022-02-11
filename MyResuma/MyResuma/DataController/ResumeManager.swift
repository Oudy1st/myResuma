//
//  ResumeManager.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import Foundation


class ResumeManager {
    
    static func loadResumeList() -> [ResumeInfo] {
        if let resumeList:[ResumeInfo] = LocalData.loadObject(.resumeList) {
            return resumeList
        }
        else {
            return [ResumeInfo]()
        }
    }
    
    static func loadResume(_ resumeID:String) -> ResumeInfo? {
        if let resumeList:[ResumeInfo] = LocalData.loadObject(.resumeList) {
            return resumeList.first(where: { $0.resumeID == resumeID })
        }
        else {
            return nil
        }
    }
    
    
    static func saveResumeList(resumeList:[ResumeInfo]) -> Bool {
        return LocalData.saveObject(.resumeList, item: resumeList)
    }
    
    static func addResume(resume:ResumeInfo) -> Bool {
        var resumeList:[ResumeInfo]? = LocalData.loadObject(.resumeList)
        
        if resumeList == nil {
            resumeList = [ResumeInfo]()
        }
        
        resumeList!.append(resume)
        
        return ResumeManager.saveResumeList(resumeList: resumeList!)
        
    }
    
    static func updateResume(resume:ResumeInfo) -> Bool {
        if var resumeList:[ResumeInfo] = LocalData.loadObject(.resumeList) {
            if let index = resumeList.firstIndex(where: { $0.resumeID == resume.resumeID }) {
                resumeList.remove(at: index)
                resumeList.insert(resume, at: index)
                return ResumeManager.saveResumeList(resumeList: resumeList)
            }
        }
        
        return false
    }
    
    static func deleteResume(resumeID:String) -> Bool {
        if var resumeList:[ResumeInfo] = LocalData.loadObject(.resumeList) {
            if let index = resumeList.firstIndex(where: { $0.resumeID == resumeID }) {
                resumeList.remove(at: index)
                return ResumeManager.saveResumeList(resumeList: resumeList)
            }
        }
        
        return false
    }
    
    
}
