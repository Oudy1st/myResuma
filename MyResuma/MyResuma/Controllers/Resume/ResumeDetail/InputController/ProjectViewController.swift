//
//  ProjectViewController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 12/2/2565 BE.
//

import UIKit
protocol ProjectViewControllerDelegate {
    func getEditingProject() -> ProjectExperience?
    
    func saveProjectExperience(_ info:ProjectExperience)
    func cancel()
}

class ProjectViewController: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtTeamSize: UITextField!
    @IBOutlet weak var txtRole: UITextField!
    @IBOutlet weak var txtTechUsed: UITextField!
    @IBOutlet weak var txtSummary: UITextView!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var delegate:ProjectViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
        self.txtName.inputAccessoryView = self.btnSave
        self.txtTeamSize.inputAccessoryView = self.btnSave
        self.txtRole.inputAccessoryView = self.btnSave
        self.txtTechUsed.inputAccessoryView = self.btnSave
        self.txtSummary.inputAccessoryView = self.btnSave
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let info = self.delegate?.getEditingProject() {
            self.txtName.text = info.name
            self.txtTeamSize.text = info.teamSize
            self.txtRole.text = info.role
            self.txtTechUsed.text = info.techUsed
            self.txtSummary.text = info.summary
        }
        
        self.txtName.becomeFirstResponder()
    }
    
    @IBAction func btnSaveDidTapped(_ sender: Any) {
        var info = self.delegate?.getEditingProject()
        if info == nil {
            info = ProjectExperience()
        }
        if let name = self.txtName.text,
           let teamSize = self.txtTeamSize.text,
           let techUsed = self.txtTechUsed.text,
           let role = self.txtRole.text,
            let summary = self.txtSummary.text
        {
            
            info!.name = name
            info!.teamSize = teamSize
            info!.techUsed = techUsed
            info!.role = role
            info!.summary = summary
            
            
            self.delegate?.saveProjectExperience(info!)
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.lblError.text = "please input all information."
        }
    }
}
