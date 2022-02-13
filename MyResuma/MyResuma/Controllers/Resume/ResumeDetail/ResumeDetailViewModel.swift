//
//  ResumeDetailViewModel.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import Foundation
import UIKit


public class ResumeDetailViewModel {
    
    var editingResumeID:String! {
        didSet {
            self.reloadResume()
        }
    }
    
    var editingWork:WorkExperience?
    var editingEducation:Education?
    var editingProject:ProjectExperience?
    
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
    
    func updateAndReloadResume() {
        if ResumeManager.updateResume(resume: self.resume.value) {
            self.reloadResume()
        }
        else {
            self.errorCannotUpdate()
        }
    }
    
    
}



//MARK:- handler value
extension ResumeDetailViewModel {
    func updateTitle(_ input:String) {
        if self.resume.value.title != input {
            self.resume.value.title = input
            self.updateAndReloadResume()
        }
    }
    
    func updateProfileImage(_ pickedImage:UIImage) {
        if let imageData = pickedImage.resizeImage(targetSize: CGSize.init(width: 120, height: 120)).pngData() {
            self.resume.value.profileImageData = imageData
            self.updateAndReloadResume()
        }
        else {
            self.errorCannotUpdate()
        }
    }
    
    func updateName(_ input:String?) {
        if self.resume.value.name != input {
            self.resume.value.name = input
            if !ResumeManager.updateResume(resume: self.resume.value) {
                self.errorCannotUpdate()
            }
        }
    }
    
    func updateMobile(_ input:String?) {
        if self.resume.value.mobile != input {
            self.resume.value.mobile = input
            if !ResumeManager.updateResume(resume: self.resume.value) {
                self.errorCannotUpdate()
            }
        }
    }
    
    func updateEmail(_ input:String?) {
        if self.resume.value.email != input {
            self.resume.value.email = input
            if !ResumeManager.updateResume(resume: self.resume.value) {
                self.errorCannotUpdate()
            }
        }
    }
    
    func updateTotalYear(_ input:String?) {
        if self.resume.value.totalYearOfExp != input {
            self.resume.value.totalYearOfExp = input
            if !ResumeManager.updateResume(resume: self.resume.value) {
                self.errorCannotUpdate()
            }
        }
    }
    
    func updateAddress(_ input:String?) {
        if self.resume.value.address != input {
            self.resume.value.address = input
            if !ResumeManager.updateResume(resume: self.resume.value) {
                self.errorCannotUpdate()
            }
        }
    }
    
    func updateObjective(_ input:String?) {
        if self.resume.value.careerObjective != input {
            self.resume.value.careerObjective = input
            if !ResumeManager.updateResume(resume: self.resume.value) {
                self.errorCannotUpdate()
            }
        }
    }
    
    func addNewSkills(_ skillString:String)  {
        
        let skillList = skillString.components(separatedBy: ",").map { string in
            string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var skills = self.resume.value.skills
        if skills == nil {
            skills = [Skill]()
        }
        
        for skillName in skillList {
            if skills?.first(where: { $0.name == skillName }) == nil {
                let newSkill = Skill()
                newSkill.name = skillName
                skills?.append(newSkill)
            }
        }
        
        self.resume.value.skills = skills
        self.updateAndReloadResume()
    }
    
    
    func deleteItem(indexPath:IndexPath)  {
        switch indexPath.section {
        case 0 :
            let info = self.getWorkInfo(indexPath.row)
            self.resume.value.workExperiences?.removeAll(where: { $0.workID == info!.workID })
            self.updateAndReloadResume()
            return
            
        case 1 :
            let info = self.getSkillInfo(indexPath.row)
            self.resume.value.skills?.removeAll(where: { $0.skillID == info!.skillID })
            self.updateAndReloadResume()
            return
            
        case 2 :
            let info = self.getEducationInfo(indexPath.row)
            self.resume.value.educations?.removeAll(where: { $0.educationID == info!.educationID })
            self.updateAndReloadResume()
            return
            
        case 3 :
            let info = self.getProjectInfo(indexPath.row)
            self.resume.value.projectExperiences?.removeAll(where: { $0.projectID == info!.projectID })
            self.updateAndReloadResume()
            return
            
        default:
            return
        }
    }
    
}

//MARK:- get content value
extension ResumeDetailViewModel {
    /// generate priview text as DisplayItem
    func getDisplayItemAtDisplayIndexPath(_ indexPath:IndexPath) -> DisplayItem? {
        switch indexPath.section {
        case 0 :
            guard let info = self.getWorkInfo(indexPath.row) else {
                return nil
            }
            
            let startYear = info.startYear!
            let endYear = (info.endYear?.count ?? 0) == 0 ? "present" : info.endYear!
            let title = "\(startYear) - \(endYear)"
            let detail = info.companyName!
            
            return DisplayItem.init(title: title, detail: detail)
            
        case 1 :
            guard let info = self.getSkillInfo(indexPath.row) else {
                return nil
            }
            
            let title = info.name!
            let detail = ""
            
            return DisplayItem.init(title: title, detail: detail)
            
        case 2 :
            guard let info = self.getEducationInfo(indexPath.row) else {
                return nil
            }
            
            let title = info.name!
            let score = info.isPercentage! ? "\(info.score!)%" : "CGPA \(info.score!)"
            let detail = """
                        \(info.level!), \(info.passingYear!)
                        \(score)
                        """
            
            return DisplayItem.init(title: title, detail: detail)
            
        case 3 :
            guard let info = self.getProjectInfo(indexPath.row) else {
                return nil
            }
            
            let title = """
                        \(info.name!)
                          Role : \(info.role!), Team Size : \(info.teamSize!)
                          Technology used : \(info.techUsed!)
                        """
            let detail = """
                           \(info.summary!)
                        """
            
            return DisplayItem.init(title: title, detail: detail)
            
        default:
            return nil
        }
    }
    
    func getWorkInfo(_ index:Int) -> WorkExperience? {
        if index >= self.resume.value.workExperiences?.count ?? 0 {
            return nil
        }
        else {
            return self.resume.value.workExperiences![index]
        }
    }
    
    func getSkillInfo(_ index:Int) -> Skill? {
        if index >= self.resume.value.skills?.count ?? 0 {
            return nil
        }
        else {
            return self.resume.value.skills![index]
        }
    }
    
    func getEducationInfo(_ index:Int) -> Education? {
        if index >= self.resume.value.educations?.count ?? 0 {
            return nil
        }
        else {
            return self.resume.value.educations![index]
        }
    }
    
    func getProjectInfo(_ index:Int) -> ProjectExperience? {
        if index >= self.resume.value.projectExperiences?.count ?? 0 {
            return nil
        }
        else {
            return self.resume.value.projectExperiences![index]
        }
    }
}

//MARK: - work input delegate
extension ResumeDetailViewModel : WorkExperienceViewControllerDelegate,
                                  EducationViewControllerDelegate,
                                  ProjectViewControllerDelegate {
 
    
    func setupWorkInput(_ index:Int? = nil, complement: (() -> Void)? = nil)  {
        if index != nil {
            self.editingWork = self.resume.value.workExperiences![index!]
        }
        
        complement?()
    }
    func setupEducationInput(_ index:Int? = nil, complement: (() -> Void)? = nil)  {
        if index != nil {
            self.editingEducation = self.resume.value.educations![index!]
        }
        
        complement?()
    }
    func setupProjectInput(_ index:Int? = nil, complement: (() -> Void)? = nil)  {
        if index != nil {
            self.editingProject = self.resume.value.projectExperiences![index!]
        }
        
        complement?()
    }
    
    func getEditingEducation() -> Education? {
        return editingEducation
    }
    func getEditingProject() -> ProjectExperience? {
        return editingProject
    }
    func getEditingWorkExperience() -> WorkExperience? {
        return editingWork
    }
    
    func saveWorkExperience(_ info: WorkExperience) {
        if self.editingWork == nil {
            if self.resume.value.workExperiences == nil {
                self.resume.value.workExperiences = [WorkExperience]()
            }
            
            self.resume.value.workExperiences?.append(info)
        }
        self.updateAndReloadResume()
    }
    
    func saveEducation(_ info: Education) {
        if self.editingEducation == nil {
            if self.resume.value.educations == nil {
                self.resume.value.educations = [Education]()
            }
            
            self.resume.value.educations?.append(info)
        }
        self.updateAndReloadResume()
    }
    
    
    func saveProjectExperience(_ info: ProjectExperience) {
        if self.editingProject == nil {
            if self.resume.value.projectExperiences == nil {
                self.resume.value.projectExperiences = [ProjectExperience]()
            }
            
            self.resume.value.projectExperiences?.append(info)
        }
        self.updateAndReloadResume()
    }
    
    
    func cancel() {
        self.editingWork = nil
        self.editingEducation = nil
        self.editingProject = nil
    }
}


//MARK:- error
extension ResumeDetailViewModel {
    func prepareExportResume(_ complement: (() -> Void)? = nil)  {
        if ResumeManager.saveExportingResume(resume: self.resume.value) {
            complement?()
        }
        else {
            self.errorCannotExport()
        }
    }
}

//MARK:- error
extension ResumeDetailViewModel {
    func errorCannotUpdate() {
        let errorAlert = ErrorAlert.init("Something went wrong.", message: "We cannot update this resume.")
        self.errorAlert.value = errorAlert
    }
    
    func errorCannotExport() {
        let errorAlert = ErrorAlert.init("Something went wrong.", message: "We cannot export this resume.")
        self.errorAlert.value = errorAlert
    }
}
