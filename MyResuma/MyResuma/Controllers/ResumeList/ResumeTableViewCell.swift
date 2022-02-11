//
//  ResumeTableViewCell.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import UIKit

protocol ResumeTableViewCellDelegate {
    func resumeTableViewCellRequestCopy(cell:ResumeTableViewCell)
    func resumeTableViewCellRequestDelete(cell:ResumeTableViewCell)
}

class ResumeTableViewCell: UITableViewCell {
    
    private var delegate:ResumeTableViewCellDelegate?
    
    var resumeInfo:ResumeInfo!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(info:ResumeInfo, delegate:ResumeTableViewCellDelegate)  {
        self.resumeInfo = info
        self.delegate = delegate
        
        self.lblTitle.text = info.title
        self.imageViewProfile.image = info.profileImage()
        

    }
    
    
    @IBAction func btnCopyDidTapped(_ sender: Any) {
        self.delegate?.resumeTableViewCellRequestCopy(cell: self)
    }
    
    @IBAction func btnDeleteDidTapped(_ sender: Any) {
        self.delegate?.resumeTableViewCellRequestDelete(cell: self)
        
    }

}
