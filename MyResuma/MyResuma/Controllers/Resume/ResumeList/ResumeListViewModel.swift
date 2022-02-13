//
//  ResumeListViewControllerModel.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import Foundation


public class ResumeListViewModel {
    
    var resumeList = Box.init([ResumeInfo]())
    var errorAlert:Box<ErrorAlert?> = Box.init(nil)
    
    
    func reloadResume()  {
        self.resumeList.value = ResumeManager.loadResumeList()
    }
    
    func addResume(_ resume:ResumeInfo) {
        if ResumeManager.addResume(resume: resume) {
            self.reloadResume()
        }
        else {
            let errorAlert = ErrorAlert.init("Something went wrong.", message: "We cannot create new resume.")
            self.errorAlert.value = errorAlert
        }
        
    }
    
    func deleteResume(_ resume:ResumeInfo)  {
        if ResumeManager.deleteResume(resumeID: resume.resumeID) {
            self.reloadResume()
        }
        else {
            let errorAlert = ErrorAlert.init("Something went wrong.", message: "We cannot delete this resume.")
            self.errorAlert.value = errorAlert
        }
    }
}
