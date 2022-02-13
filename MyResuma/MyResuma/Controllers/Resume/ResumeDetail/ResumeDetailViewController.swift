//
//  ResumeDetailViewController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import UIKit

struct DisplayItem {
    let title:String
    let detail:String
}

class ResumeDetailViewController: UIViewController {
    
    private let viewModel = ResumeDetailViewModel()
    
    var imagePickerController:UIImagePickerController!
    
    @IBOutlet weak var tableViewResumeDetail: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTotalYear: UITextField!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtObjective: UITextView!
    
    func setEditingResume(_ resumeID:String)  {
        self.viewModel.editingResumeID = resumeID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.viewModel.resume.bind { [weak self] resumeInfo in
            self?.title = resumeInfo.title
            
            self?.imageViewProfile.image = resumeInfo.profileImage()
            
            self?.txtMobile.text = resumeInfo.mobile
            self?.txtEmail.text = resumeInfo.email
            self?.txtAddress.text = resumeInfo.address
            self?.txtTotalYear.text = resumeInfo.totalYearOfExp
            self?.txtObjective.text = resumeInfo.careerObjective
            
            self?.tableViewResumeDetail.reloadData()
        }
        
        self.viewModel.errorAlert.bind { [weak self] errorAlert in
            if let alertC = errorAlert?.generateAlertController() {
                self?.present(alertC, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableViewResumeDetail.registerKeyboardNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableViewResumeDetail.unregisterKeyboardNotificationCenter()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let vc as WorkExperienceViewController:
            vc.delegate = self.viewModel
            break
            
        case let vc as ProjectViewController:
            vc.delegate = self.viewModel
            break
            
        case let vc as EducationViewController:
            vc.delegate = self.viewModel
            break
            
        default:
            break
        }
    }
    

    
    // MARK: - Action
    
    @IBAction func btnExportDidTapped(_ sender: Any) {
        self.viewModel.prepareExportResume {
            self.performSegue(withIdentifier: "goExport", sender:nil)
        }
    }

    @IBAction func headerDidTapped(_ sender: Any) {
        self.tableViewResumeDetail.endEditing(true)
    }
    
    @IBAction func btnCameraDidTapped(_ sender: Any) {
        self.openImagePicker()
    }
    
    @IBAction func btnEditTitleDidTapped(_ sender: Any) {
        let resume = self.viewModel.resume.value
        
        let alertC = UIAlertController.init(title: "Please enter your resume title.", message: nil, preferredStyle: .alert)
        alertC.addTextField { textField in
            textField.text = resume.title
        }
        alertC.addAction(UIAlertAction.init(title: "Edit", style: .default, handler: { [weak alertC] _ in
            let title = alertC?.textFields?.first?.text ?? ""
            self.viewModel.updateTitle(title)
        }))
        alertC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertC, animated: true, completion: nil)
    }
}


//MARK: - TableView Delegate
extension ResumeDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch section {
        case 0 : return (self.viewModel.resume.value.workExperiences?.count ?? 0)
        case 1 : return (self.viewModel.resume.value.skills?.count ?? 0)
        case 2 : return (self.viewModel.resume.value.educations?.count ?? 0)
        case 3 : return (self.viewModel.resume.value.projectExperiences?.count ?? 0)
            
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0 : return "Work Summary"
//        case 1 : return "Skills"
//        case 2 : return "Education Details"
//        case 3 : return "Project Details"
//            
//        default:
//            return "Unknown"
//        }
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = headerView.copyView()
        let lblTitle = view?.viewWithTag(1) as? UILabel
        let btnAdd = view?.viewWithTag(2) as? UIButton
        btnAdd?.cornerRadius = (btnAdd?.frame.size.width) ?? 0
//        btnAdd?.cornerRadius = ((btnAdd?.frame.size.width) ?? 0)/2.0
        switch section {
        case 0 : lblTitle?.text = "Work Summary"
            btnAdd?.addAction(for: .touchUpInside, action: {
                self.showWorkInput()
            })
            break
        case 1 : lblTitle?.text = "Skills"
            btnAdd?.addAction(for: .touchUpInside, action: {
                self.showSkillInput()
            })
            break
        case 2 : lblTitle?.text = "Education Details"
            btnAdd?.addAction(for: .touchUpInside, action: {
                self.showEducationInput()
            })
            break
        case 3 : lblTitle?.text = "Project Details"
            btnAdd?.addAction(for: .touchUpInside, action: {
                self.showProjectInput()
            })
            break

            
            
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let displayItem = self.viewModel.getDisplayItemAtDisplayIndexPath(indexPath)
        
        
        switch indexPath.section {
        case 0 : // "Work Summary"
            break
        case 1 : // "Skills"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell")!
            
            let lblTitle = cell.viewWithTag(1) as? UILabel
            
            lblTitle?.text = displayItem!.title
            
            return cell
            
        case 2 : // "Education Details"
            break
        case 3 : // "Project Details"
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell")!
            
            let lblTitle = cell.viewWithTag(1) as? UILabel
            let lblDetail = cell.viewWithTag(2) as? UILabel
            
            lblTitle?.text = displayItem!.title
            lblDetail?.text = displayItem!.detail
            
            return cell
        default:
            //
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
        
        let lblTitle = cell.viewWithTag(1) as? UILabel
        let lblDetail = cell.viewWithTag(2) as? UILabel
        
        lblTitle?.text = displayItem!.title
        lblDetail?.text = displayItem!.detail
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0 :
            self.showWorkInput(indexPath.row)
            break
        case 1 :
            break
        case 2 :
            self.showEducationInput(indexPath.row)
            break
        case 3 :
            self.showProjectInput(indexPath.row)
            break

            
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return  self.viewModel.getDisplayItemAtDisplayIndexPath(indexPath) != nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete
            self.viewModel.deleteItem(indexPath: indexPath)
        }
    }

}

//MARK: - Show Input Options

extension ResumeDetailViewController {
    func showWorkInput(_ index:Int? = nil) {
        self.viewModel.setupWorkInput(index) {
            self.performSegue(withIdentifier: "addWork", sender: nil)
        }
    }
    
    
    func showSkillInput() {
        
        let alertC = UIAlertController.init(title: "Please enter your skills.", message: "you can seperate with comma(,).", preferredStyle: .alert)
        alertC.addTextField { textField in
            textField.placeholder = "ex. excel,swift,kotlin,go"
        }
        alertC.addAction(UIAlertAction.init(title: "Save", style: .default, handler: { [weak alertC] _ in
            let skillString = alertC?.textFields?.first?.text ?? ""
            
            self.viewModel.addNewSkills(skillString)
            
        }))
        alertC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertC, animated: true, completion: nil)
    }
    
    func showEducationInput(_ index:Int? = nil) {
        self.viewModel.setupEducationInput(index) {
            self.performSegue(withIdentifier: "addEducation", sender: nil)
        }
    }
    
    func showProjectInput(_ index:Int? = nil) {
        self.viewModel.setupProjectInput(index) {
            self.performSegue(withIdentifier: "addProject", sender: nil)
        }
    }
}


//MARK: - Text Input Delegate
extension ResumeDetailViewController : UITextFieldDelegate, UITextViewDelegate {
 
    
    func scrollRectToVisible(_ view:UIView) {
        
        var onTableViewFrame = view.convert(view.frame, to: self.tableViewResumeDetail)
        
        //prevent offscreen
        onTableViewFrame.origin.x = 0
        //show some next item
        onTableViewFrame.size.height *= 2.0
        
        self.tableViewResumeDetail.scrollRectToVisible(onTableViewFrame, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollRectToVisible(textField)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollRectToVisible(textView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txtMobile :
            self.viewModel.updateMobile(self.txtMobile.text)
            break
        case self.txtEmail :
            self.viewModel.updateEmail(self.txtEmail.text)
            break
        case self.txtTotalYear :
            self.viewModel.updateTotalYear(self.txtTotalYear.text)
            break
        default:
            break
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case self.txtObjective :
            self.viewModel.updateObjective(self.txtObjective.text)
            break
        case self.txtAddress :
            self.viewModel.updateAddress(self.txtAddress.text)
            break
        default:
            break
        }
    }
    
    
    
}

//MARK: - Image Picker Delegate
extension ResumeDetailViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openImagePicker() {
        self.imagePickerController = UIImagePickerController()
        

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.cameraCaptureMode = .photo
        }
        else
        {
            self.imagePickerController.sourceType = .savedPhotosAlbum
        }
        self.imagePickerController.delegate = self


        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        DispatchQueue.main.async {
            
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
               let croppedImage = pickedImage.cropImageToSquare()
            {
                self.viewModel.updateProfileImage(croppedImage)
            }


            picker.dismiss(animated: true, completion: nil)

        }
    }
}
