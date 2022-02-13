//
//  WorkExperienceViewController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 12/2/2565 BE.
//

import UIKit

protocol WorkExperienceViewControllerDelegate {
    func getEditingWorkExperience() -> WorkExperience?
    
    func saveWorkExperience(_ info:WorkExperience)
    func cancel()
}

class WorkExperienceViewController: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtStartYear: UITextField!
    @IBOutlet weak var txtEndYear: UITextField!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var delegate:WorkExperienceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.txtName.inputAccessoryView = self.btnSave
        self.txtStartYear.inputAccessoryView = self.btnSave
        self.txtEndYear.inputAccessoryView = self.btnSave
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let info = self.delegate?.getEditingWorkExperience() {
            self.txtName.text = info.companyName
            self.txtStartYear.text = info.startYear
            self.txtEndYear.text = info.endYear
        }
        
        self.txtName.becomeFirstResponder()
    }
    
    
    @IBAction func btnSaveDidTapped(_ sender: Any) {
        var info = self.delegate?.getEditingWorkExperience()
        if info == nil {
            info = WorkExperience()
        }
        if let name = self.txtName.text,
           let startYearString = self.txtStartYear.text
//           startYearString.count == 4,
//           (self.txtEndYear.text?.count ?? 0 == 0 || self.txtEndYear.text?.count ?? 0 == 4)
        {
            
            info!.companyName = name
            info!.startYear = startYearString
            info!.endYear = (self.txtEndYear.text?.count ?? 0 == 0) ? nil : self.txtEndYear.text
            
            self.delegate?.saveWorkExperience(info!)
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.lblError.text = "please input all information."
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
