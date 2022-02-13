//
//  PDFPreviewViewController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/2/2565 BE.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    
    private let viewModel = PDFPreviewViewModel()
    @IBOutlet weak var viewPreview: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.viewModel.pdfData.bind { [weak self] pdfData in
            if pdfData != nil {
                self?.viewPreview.document = PDFDocument.init(data: pdfData!)
                self?.viewPreview.autoScales = true
            }
            else {
                let alertC = UIAlertController.init(title: "Something went wrong.", message: "We cannot create PDF for this resume.", preferredStyle: .alert)
                alertC.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                
                self?.present(alertC, animated: true, completion: nil)
            }
        }
        
        self.viewModel.resume.bind { [weak self] resume in
            self?.title = resume?.title
        }
        
        
        self.viewModel.errorAlert.bind { [weak self] errorAlert in
            if let alertC = errorAlert?.generateAlertController() {
                self?.present(alertC, animated: true, completion: nil)
            }
        }
    }
    
    
    func prepareTemplate(template:TemplateInfo) {
        self.viewModel.setupDisplayResume(template: template)
    }
    
    // MARK: - Action
    @IBAction func btnShareDidTapped(_ sender: Any) {
        self.viewModel.preparePDFFile { url in
            
            let activityVC = UIActivityViewController.init(activityItems: [url], applicationActivities: nil)
            present(activityVC, animated: true)
        }
    }
}
