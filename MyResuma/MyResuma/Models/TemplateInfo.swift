//
//  TemplateInfo.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/2/2565 BE.
//

import Foundation
import UIKit

struct TemplateInfo {
    let name:String
    let imageName:String
    let templateLayout:TemplateLayout
    let config:TemplateConfiguration
}


class TemplateConfiguration {
    var margin:UIEdgeInsets = UIEdgeInsets.init(top: 32, left: 32, bottom: 32, right: 32)
    
    var headerFont:UIFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    var headerTextColor:UIColor = .black
    var headerBarColor:UIColor = .clear
    
    var subHeaderFont:UIFont = UIFont.systemFont(ofSize: 28, weight: .thin)
    var subHeaderTextColor:UIColor = .black
    
    var bodyFont:UIFont = UIFont.systemFont(ofSize: 30, weight: .regular)
    var bodyTextColor:UIColor = .darkGray
    
    let pageWidth = 8.3 * 96.0
    let pageHeight = 11.7 * 96.0
    var pageRect:CGRect {
        get {
            return CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        }
    }
    
    var lineMargin:CGFloat = 8
    var sectionMargin:CGFloat = 24
    
}

