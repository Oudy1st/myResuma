//
//  PDFLayoutClassic.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/2/2565 BE.
//

import PDFKit

extension PDFCreator {
    func generatClassicLayoutPDF(context:UIGraphicsPDFRendererContext) {
        let pageRect = self.config.pageRect
        
        let startX = self.config.margin.left
        let startY = self.config.margin.top
        
        let lineMargin:CGFloat = self.config.lineMargin
        let sectionMargin:CGFloat = self.config.sectionMargin
        
        
        //pre-calculation
        var currentDrawPosition = CGPoint(x: startX, y: startY)
        let preferFullPageWidth = (self.config.pageWidth - self.config.margin.left - self.config.margin.right)
        
        
        context.beginPage()
        var lastDrawPosition = CGPoint()
        
        ///header
        let profileSize = CGSize(width: 150, height: 225)
        let profileMargin:CGFloat = 16
        let rightProfileWidth = profileSize.width + (profileMargin)
        let rightProfileX = preferFullPageWidth - rightProfileWidth
        
        let leftHeaderWidth = preferFullPageWidth - rightProfileWidth
        
        //add fullname
        lastDrawPosition = self.addText(context,text: resume.name ?? "My Resuma",
                                        pageRect: pageRect,
                                        position: currentDrawPosition,
                                        preferWidth: leftHeaderWidth,
                                            textFont: config.headerFont,
                                            textColor: config.headerTextColor
        )
        
        // add email, phone, address
        let textList:[(String, String?)] = [("ic_email",resume.email),
                                                          ("ic_phone",resume.mobile),
                                                          ("ic_address",resume.address)]
        for case let (iconName,text) as (String,String) in textList {
            currentDrawPosition.x = startX
            currentDrawPosition.y = lastDrawPosition.y + lineMargin
            
            //draw icon
            let iconImage = UIImage.init(named: iconName)!
            let iconRect = CGRect.init(x: currentDrawPosition.x, y: currentDrawPosition.y + 4, width: 30, height: 30)
            self.addImage(image: iconImage, rect: iconRect)
            
            //draw text
            currentDrawPosition.x += iconRect.width + 8
            lastDrawPosition = self.addText(context, text: text,
                                            pageRect: pageRect,
                                            position: currentDrawPosition,
                                            preferWidth: leftHeaderWidth - iconRect.origin.x - iconRect.size.width,
                                            textFont: config.bodyFont,
                                            textColor: config.bodyTextColor
                                            )
        }
        
        //add profile on the right side
        let image = resume.profileImage()
        let imageRect = CGRect(x: rightProfileX, y: startY, width: profileSize.width, height: profileSize.height)
        self.addImage(image: image, rect: imageRect)
        
        // cal for last Y
        if lastDrawPosition.y < imageRect.origin.y + imageRect.size.height
        {
            lastDrawPosition.y = imageRect.origin.y + imageRect.size.height
        }
        
        //add objective
        if let careerObjective = resume.careerObjective {
            currentDrawPosition.x = startX
            currentDrawPosition.y = lastDrawPosition.y + sectionMargin
            lastDrawPosition = self.addText(context, text: "Career Objective",
                                            pageRect: pageRect,
                                            position: currentDrawPosition,
                                            preferWidth: preferFullPageWidth,
                                            textFont: config.headerFont,
                                            textColor: config.headerTextColor
                                            )
            
            currentDrawPosition.x = startX
            currentDrawPosition.y = lastDrawPosition.y + lineMargin
            lastDrawPosition = self.addText(context, text: careerObjective,
                                            pageRect: pageRect,
                                            position: currentDrawPosition,
                                            preferWidth: preferFullPageWidth,
                                            textFont: config.bodyFont,
                                            textColor: config.bodyTextColor
                                            )
        }
        
        //add skills
        if let skills = resume.skills, skills.count > 0 {
            currentDrawPosition.x = startX
            currentDrawPosition.y = lastDrawPosition.y + sectionMargin
            lastDrawPosition = self.addText(context, text: "Skills",
                                            pageRect: pageRect,
                                            position: currentDrawPosition,
                                            preferWidth: preferFullPageWidth,
                                            textFont: config.headerFont,
                                            textColor: config.headerTextColor
                                            )
            
            currentDrawPosition.x = startX
            currentDrawPosition.y = lastDrawPosition.y + lineMargin
            let displaySkill = skills.map({ $0.name! }).joined(separator: ", ")
            lastDrawPosition = self.addText(context, text: displaySkill,
                                            pageRect: pageRect,
                                            position: currentDrawPosition,
                                            preferWidth: preferFullPageWidth,
                                            textFont: config.bodyFont,
                                            textColor: config.bodyTextColor
                                            )
        }
        
        //add work summary
        if let workExperiences = resume.workExperiences, workExperiences.count > 0 {
            currentDrawPosition.x = startX
            currentDrawPosition.y = lastDrawPosition.y + sectionMargin
            lastDrawPosition = self.addText(context, text: "Experience",
                                            pageRect: pageRect,
                                            position: currentDrawPosition,
                                            preferWidth: preferFullPageWidth,
                                            textFont: config.headerFont,
                                            textColor: config.headerTextColor
                                            )
            
            for workExperience in workExperiences {
                currentDrawPosition.x = startX
                currentDrawPosition.y = lastDrawPosition.y + lineMargin
                let displayText = "\(workExperience.displayYearRange()),   \(workExperience.companyName!)"
                
                lastDrawPosition = self.addText( context,text:displayText,
                                                pageRect: pageRect,
                                                position: currentDrawPosition,
                                                preferWidth: preferFullPageWidth,
                                                textFont: config.bodyFont,
                                            textColor: config.bodyTextColor
                                                )
            }
        }
        
        //add education
        if let educations = resume.educations, educations.count > 0 {
            currentDrawPosition.x = startX
            currentDrawPosition.y = lastDrawPosition.y + sectionMargin
            lastDrawPosition = self.addText(context, text: "Educations",
                                            pageRect: pageRect,
                                            position: currentDrawPosition,
                                            preferWidth: preferFullPageWidth,
                                            textFont: config.headerFont,
                                            textColor: config.headerTextColor
                                            )
            
            for education in educations {
                currentDrawPosition.x = startX
                currentDrawPosition.y = lastDrawPosition.y + lineMargin
                var displayText = "\(education.name!), \(education.level!) -- "
                
                let formatter = NumberFormatter.init()
                formatter.numberStyle = .decimal
                
                if let scoreText = education.score,
                   let score = formatter.number(from: scoreText)
                {
                    if education.isPercentage ?? true {
                        formatter.maximumFractionDigits = 0
                        
                        displayText.append("\(formatter.string(from: score)!)%")
                    }
                    else {
                        formatter.maximumFractionDigits = 2
                        displayText.append("\(formatter.string(from: score)!)")
                    }
                    displayText.append(", \(education.passingYear!)")
                }
                lastDrawPosition = self.addText(context, text:displayText,
                                                pageRect: pageRect,
                                                position: currentDrawPosition,
                                                preferWidth: preferFullPageWidth,
                                                textFont: config.bodyFont,
                                            textColor: config.bodyTextColor
                                                )
            }
        }
        
        //add project summary
        if let projectExperiences = resume.projectExperiences, projectExperiences.count > 0 {
            currentDrawPosition.x = startX
            currentDrawPosition.y = lastDrawPosition.y + sectionMargin
            lastDrawPosition = self.addText(context, text: "Project Experience",
                                            pageRect: pageRect,
                                            position: currentDrawPosition,
                                            preferWidth: preferFullPageWidth,
                                            textFont: config.headerFont,
                                            textColor: config.headerTextColor
                                            )
            
            for projectInfo in projectExperiences {
                
                // project title
                currentDrawPosition.x = startX
                currentDrawPosition.y = lastDrawPosition.y + lineMargin
                var displayText = "\(projectInfo.role!) in \(projectInfo.name!) Project, Team Size: \(projectInfo.teamSize!)"
                lastDrawPosition = self.addText(context, text:displayText,
                                                pageRect: pageRect,
                                                position: currentDrawPosition,
                                                preferWidth: preferFullPageWidth,
                                                textFont: config.bodyFont,
                                            textColor: config.bodyTextColor
                                                )
                
                // tech
                currentDrawPosition.x = startX
                currentDrawPosition.y = lastDrawPosition.y + lineMargin
                displayText = "Technology used: \(projectInfo.techUsed!)"
                lastDrawPosition = self.addText(context, text:displayText,
                                                pageRect: pageRect,
                                                position: currentDrawPosition,
                                                preferWidth: preferFullPageWidth,
                                                textFont: config.subHeaderFont,
                                                textColor: config.subHeaderTextColor
                                                )
                
                // summary
                currentDrawPosition.x = startX
                currentDrawPosition.y = lastDrawPosition.y + lineMargin
                displayText = "       \(projectInfo.summary!)"
                lastDrawPosition = self.addText(context, text:displayText,
                                                pageRect: pageRect,
                                                position: currentDrawPosition,
                                                preferWidth: preferFullPageWidth,
                                                textFont: config.bodyFont,
                                            textColor: config.bodyTextColor
                                                )
            }
        }
    }
}
