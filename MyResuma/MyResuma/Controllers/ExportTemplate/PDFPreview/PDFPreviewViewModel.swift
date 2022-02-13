//
//  PDFPreviewViewModel.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/2/2565 BE.
//

import Foundation
import PDFKit


public class PDFPreviewViewModel {
    
    var pdfData:Box<Data?> = Box(nil)
    var errorAlert:Box<ErrorAlert?> = Box.init(nil)
    
    
    var template:TemplateInfo!
    var resume:Box<ResumeInfo?> = Box.init(nil)
    
    func setupDisplayResume(template:TemplateInfo)  {
        self.template = template
        
        if let resume:ResumeInfo = ResumeManager.loadExportingResume() {
            self.resume.value = resume
            
            self.pdfData.value = PDFCreator().createPDF(resume: resume, template: self.template)
        }
        else {
            let errorAlert = ErrorAlert.init("Something went wrong.", message: "We cannot preview this resume.")
            self.errorAlert.value = errorAlert
        }
    }
    
    func preparePDFFile(completion:((URL) -> Void)) {
        if let title = self.resume.value?.title,
           let data = self.pdfData.value
        {
            let fileNmae = "\(title).pdf"
            if let url = FileHelper.saveFile(fileName: fileNmae, subDirectory: nil, data: data, category: .local) {
                completion(url)
                return
            }
        }
        
        let errorAlert = ErrorAlert.init("Something went wrong.", message: "We cannot export this resume.")
        self.errorAlert.value = errorAlert
    }
}
