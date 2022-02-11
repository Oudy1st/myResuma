//
//  ResumeDetailViewModel.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import Foundation

public class ResumeDetailViewModel {
    
    var editingResumeID:String! {
        didSet {
            self.reloadResume()
        }
    }
    
    var resume = Box.init(ResumeInfo())
    var errorAlert:Box<ErrorAlert?> = Box.init(nil)
    
    func reloadResume()  {
        if let resume = ResumeManager.loadResume(self.editingResumeID) {
            self.resume.value = resume
        }
        else {
            let errorAlert = ErrorAlert.init("Error", message: "Cannot load resume's information.")
            self.errorAlert.value = errorAlert
        }
    }
    
    func updateResume(_ resume:ResumeInfo) {
        if ResumeManager.updateResume(resume: resume) {
            self.reloadResume()
        }
        else {
            let errorAlert = ErrorAlert.init("Something went wrong.", message: "We cannot update this resume.")
            self.errorAlert.value = errorAlert
        }
    }
}
