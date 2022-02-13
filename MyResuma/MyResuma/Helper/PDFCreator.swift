//
//  PDFCreator.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/2/2565 BE.
//

import Foundation
import PDFKit


enum TemplateLayout {
    case classic, classicNoImage, bar
}

class PDFCreator {
    var config:TemplateConfiguration!
    var resume: ResumeInfo!
    
    func createPDF(resume:ResumeInfo, template:TemplateInfo) -> Data {
        self.config = template.config
        self.resume = resume
        
        let pdfMetaData = [
            kCGPDFContextCreator: "My Resuma",
            kCGPDFContextAuthor: "\(resume.name ?? "unknown")"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        
        let renderer = UIGraphicsPDFRenderer(bounds: self.config.pageRect, format: format)
        let data = renderer.pdfData { (context) in
            switch template.templateLayout {
                
            case .classic:
                self.generatClassicLayoutPDF(context: context)
            case .classicNoImage:
                self.generatClassicLayoutNoImagePDF(context: context)
            case .bar:
                self.generatBarLayoutPDF(context: context)
            }
            
        }
        
        return data
    }
    
    func addText(_ context:UIGraphicsPDFRendererContext ,text:String, pageRect: CGRect, position:CGPoint, preferWidth:CGFloat = CGFloat.greatestFiniteMagnitude, textFont:UIFont, textColor:UIColor, barColor:UIColor? = nil) -> CGPoint {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let attributedText = NSAttributedString(string: text, attributes: textAttributes)
        
        
        var textRect = attributedText.boundingRect(with: CGSize.init(width: preferWidth, height: CGFloat.greatestFiniteMagnitude),
                                                   options: .usesLineFragmentOrigin,
                                                   context: nil)
        textRect.origin = position
        
        //check and new page
        if textRect.origin.y + textRect.size.height > pageRect.size.height {
            context.beginPage()
            textRect.origin.y = self.config.margin.top
        }
        
        if let barColor = barColor {
            var barFrame = textRect
            barFrame.size.width = pageRect.size.width
            barFrame.origin.x = pageRect.origin.x
            self.addBar(color: barColor, rect: barFrame)
        }
        
        attributedText.draw(in: textRect)
        
        
        
        return CGPoint.init(x: textRect.origin.x + textRect.size.width,
                            y: textRect.origin.y + textRect.size.height)
    }
    
    func addBar(color:UIColor, rect:CGRect) {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.setFillColor(color.cgColor)
        currentContext?.fill(rect)
    }
    
    func addImage(image:UIImage, rect:CGRect) {
        
        let maxHeight = rect.height
        let maxWidth = rect.width
        
        let aspectWidth = maxWidth / image.size.width
        let aspectHeight = maxHeight / image.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        let scaledWidth = image.size.width * aspectRatio
        let scaledHeight = image.size.height * aspectRatio
        
        let imageX = rect.origin.x + ((rect.width - scaledWidth) / 2.0)
        let imageRect = CGRect(x: imageX, y: rect.origin.y,
                               width: scaledWidth, height: scaledHeight)
        
        image.draw(in: imageRect)
    }
}
