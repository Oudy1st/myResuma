//
//  EducationViewController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 12/2/2565 BE.
//

import UIKit


protocol EducationViewControllerDelegate {
    func getEditingEducation() -> Education?
    
    func saveEducation(_ info:Education)
    func cancel()
}

class EducationViewController: UIViewController {
    
    @IBOutlet weak var txtClass: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPassingYear: UITextField!
    @IBOutlet weak var txtScore: UITextField!
    @IBOutlet weak var segmentPercentage: UISegmentedControl!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var delegate:EducationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.txtName.inputAccessoryView = self.btnSave
        self.txtClass.inputAccessoryView = self.btnSave
        self.txtPassingYear.inputAccessoryView = self.btnSave
        self.txtScore.inputAccessoryView = self.btnSave
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let info = self.delegate?.getEditingEducation() {
            self.txtName.text = info.name
            self.txtClass.text = info.level
            self.txtPassingYear.text = info.passingYear
            self.txtScore.text = info.score
            
            if info.isPercentage ?? true {
                self.segmentPercentage.selectedSegmentIndex = 0
            }
            else {
                self.segmentPercentage.selectedSegmentIndex = 1
            }
        }
        
        self.txtName.becomeFirstResponder()
    }
    
    @IBAction func btnSaveDidTapped(_ sender: Any) {
        var info = self.delegate?.getEditingEducation()
        if info == nil {
            info = Education()
        }
        if let name = self.txtName.text,
           let passingYear = self.txtPassingYear.text,
           let level = self.txtClass.text,
           let score = self.txtScore.text
        {
            
            info!.name = name
            info!.passingYear = passingYear
            info!.score = score
            info!.level = level
            
            info!.isPercentage = self.segmentPercentage.selectedSegmentIndex == 0
            
            self.delegate?.saveEducation(info!)
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.lblError.text = "please input all information."
        }
    }
}
