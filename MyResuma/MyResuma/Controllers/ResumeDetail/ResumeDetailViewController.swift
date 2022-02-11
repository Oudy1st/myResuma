//
//  ResumeDetailViewController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import UIKit

class ResumeDetailViewController: UIViewController {
    
    private let viewModel = ResumeDetailViewModel()
    
    
    @IBOutlet weak var tableViewResumeDetail: UITableView!
    
    func setEditingResume(_ resumeID:String)  {
        self.viewModel.editingResumeID = resumeID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewModel.resume.bind { [weak self] resumeInfo in
            self?.title = resumeInfo.title
//            self?.tableViewResumeDetail.reloadData()
        }
        
        self.viewModel.errorAlert.bind { [weak self] errorAlert in
            if let alertC = errorAlert?.generateAlertController() {
                self?.present(alertC, animated: true, completion: nil)
            }
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

    
    // MARK: - Action

    @IBAction func btnEditTitleDidTapped(_ sender: Any) {
        let resume = self.viewModel.resume.value
        
        let alertC = UIAlertController.init(title: "Please enter your resume title.", message: nil, preferredStyle: .alert)
        alertC.addTextField { textField in
            textField.text = resume.title
        }
        alertC.addAction(UIAlertAction.init(title: "Edit", style: .default, handler: { [weak alertC] _ in
            let title = alertC?.textFields?.first?.text ?? ""
            resume.title = title.count == 0 ? "(no title)" : title
            self.viewModel.updateResume(resume)
        }))
        alertC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertC, animated: true, completion: nil)
    }
}
