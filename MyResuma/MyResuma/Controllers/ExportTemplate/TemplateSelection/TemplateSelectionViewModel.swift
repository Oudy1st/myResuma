//
//  TemplateSelectionViewModel.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/2/2565 BE.
//

import Foundation


class TemplateSelectionViewModel {
    
    var templates = [TemplateInfo]()
    var errorAlert:Box<ErrorAlert?> = Box.init(nil)
    
    func generateTemplateChoice()  {
        
        
        var config:TemplateConfiguration!
        //choice 1
        config = TemplateConfiguration()
        self.templates.append(TemplateInfo(name: "Classic",
                                imageName: "tem_classic",
                                templateLayout: .classic,
                                config: config
                                          )
                              )
        
        //choice 2
        config = TemplateConfiguration()
        self.templates.append(TemplateInfo(name: "Classic (no image)",
                                imageName: "tem_classic_no_image",
                                templateLayout: .classicNoImage,
                                config: TemplateConfiguration()
                                )
                              )
        
        
        //choice 3
        
        config = TemplateConfiguration()
        config.headerTextColor = .init(red: 0, green: 0.5, blue: 0.8, alpha: 1)
        config.headerBarColor = .systemGray6
        config.bodyTextColor = .lightGray
        config.subHeaderTextColor = .blue.withAlphaComponent(0.9)
        
        self.templates.append(TemplateInfo(name: "Bar",
                                imageName: "tem_bar",
                                templateLayout: .bar,
                                config: config
                                )
                              )
        
        
        
    }
}
