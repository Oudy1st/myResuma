//
//  ResumeListViewController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import UIKit

class ResumeListViewController: UIViewController {
    
    private let viewModel = ResumeListViewModel()

    @IBOutlet weak var tableViewResumeList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.viewModel.resumeList.bind { [weak self] list in
            self?.tableViewResumeList.reloadData()
        }
        
        self.viewModel.errorAlert.bind { [weak self] errorAlert in
            if let alertC = errorAlert?.generateAlertController() {
                self?.present(alertC, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.reloadResume()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? ResumeDetailViewController,
           let resume = sender as? ResumeInfo
        {
            vc.setEditingResume(resume.resumeID)
        }
    }
    
    // MARK: - Action

    @IBAction func btnAddDidTapped(_ sender: Any) {
        let resume = ResumeInfo()
        
        let alertC = UIAlertController.init(title: "Please enter your resume title.", message: nil, preferredStyle: .alert)
        alertC.addTextField { textField in
            textField.placeholder = "My resume"
        }
        alertC.addAction(UIAlertAction.init(title: "Create", style: .default, handler: { [weak alertC] _ in
            let title = alertC?.textFields?.first?.text ?? ""
            resume.title = title.count == 0 ? "(no title)" : title
            self.viewModel.addResume(resume)
        }))
        alertC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertC, animated: true, completion: nil)
    }
}

extension ResumeListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.resumeList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing:  ResumeTableViewCell.self)) as! ResumeTableViewCell
        
        cell.bind(info: self.viewModel.resumeList.value[indexPath.row], delegate: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goEdit", sender: self.viewModel.resumeList.value[indexPath.row])
    }
}

extension ResumeListViewController : ResumeTableViewCellDelegate {
    func resumeTableViewCellRequestCopy(cell: ResumeTableViewCell) {
        if let resume = try? cell.resumeInfo.copy() {
            resume.title = "copy of \(resume.title!)"
            
            let alertC = UIAlertController.init(title: "Please enter your resume title.", message: nil, preferredStyle: .alert)
            alertC.addTextField { textField in
                textField.text = "\(resume.title!)"
                textField.delegate = self
            }
            alertC.addAction(UIAlertAction.init(title: "Create", style: .default, handler: { [weak alertC] _ in
                let title = alertC?.textFields?.first?.text ?? ""
                resume.title = title.count == 0 ? "(no title)" : title
                self.viewModel.addResume(resume)
            }))
            alertC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertC, animated: true, completion: nil)
        
        }
        else {
            //alert cannot copy this item
            let alertC = UIAlertController.init(title: "Error", message: "Something went wrong.\r\nWe cannot duplicate this resume.", preferredStyle: .alert)
            alertC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertC, animated: true, completion: nil)
        }
    }
    func resumeTableViewCellRequestDelete(cell: ResumeTableViewCell) {
        let alertC = UIAlertController.init(title: "Do you want to delete?", message: "\(cell.resumeInfo.title!)", preferredStyle: .alert)
        alertC.addAction(UIAlertAction.init(title: "Delete", style: .default, handler: { _ in
            self.viewModel.deleteResume(cell.resumeInfo)
        }))
        alertC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertC, animated: true, completion: nil)
    }
}


extension ResumeListViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        textField.becomeFirstResponder()
        
        textField.delegate = nil
    }
}
