//
//  TemplateSelectionViewController.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/2/2565 BE.
//

import UIKit

class TemplateSelectionViewController: UIViewController {
    
    private let viewModel = TemplateSelectionViewModel()
    
    @IBOutlet weak var collectionTemplateList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewModel.generateTemplateChoice()
        
        
        self.viewModel.errorAlert.bind { [weak self] errorAlert in
            if let alertC = errorAlert?.generateAlertController() {
                self?.present(alertC, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? PDFPreviewViewController,
           let template = sender as? TemplateInfo
        {
            vc.prepareTemplate(template: template)
        }
    }
    
}

extension TemplateSelectionViewController:
    UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = self.viewModel.templates.count
        
        let blankNeeded = count % 2
        count = count + blankNeeded
        
        return count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < self.viewModel.templates.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateCell", for: indexPath)
            
            let info = self.viewModel.templates[indexPath.row]
            let imageView = cell.viewWithTag(1) as? UIImageView
            let lblName = cell.viewWithTag(2) as? UILabel
            
            imageView?.image = UIImage.init(named: info.imageName)
            lblName?.text = info.name
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blankCell", for: indexPath)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < self.viewModel.templates.count {
            
            self.performSegue(withIdentifier: "showPreview", sender: self.viewModel.templates[indexPath.row])
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize.zero
        let scaleHeight = 2.97/2.1
        cellSize.width = collectionView.frame.size.width * 0.48
        cellSize.height = (cellSize.width * scaleHeight) + 30
        
        return cellSize
    }
}
