//
//  RequestTimeOffListTableViewCell.swift
//  Skazule-Employee
//
//  Created by ChawTech Solutions on 12/04/23.
//

import UIKit


protocol  RequestTimeOffListCellDelegate{
    func onTapEdit(cell:RequestTimeOffListTableViewCell,index:Int)
    func onTapDelete(cell:RequestTimeOffListTableViewCell,index:Int)
}

class RequestTimeOffListTableViewCell: UITableViewCell{
    
    
    //MARK: IBOutlets
    
    @IBOutlet weak var employeeProfileImg: UIImageView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var requestOnLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    //MARK: Variables
    var status = ""
    var index = 0
    var textColor = UIColor.black
    
    var delegate:RequestTimeOffListCellDelegate?
    
    var padData: PADData?{
        didSet{
            guard let padData = self.padData else { return }
            self.employeeNameLabel.text = padData.employeeName ?? ""
            self.leaveTypeLabel.text = padData.leaveTypeName ?? ""
            self.startDateLabel.text = getDate(dateString: padData.startDate ?? "")
            self.endDateLabel.text = getDate(dateString: padData.endDate ?? "")
            self.statusLabel.text = status
            self.statusLabel.textColor = textColor
            self.detailLabel.text = padData.reason ?? ""
        
            self.requestOnLabel.text = getDate(dateString: padData.createdAt ?? "")//String(separatedDate.first ?? "")
            
            if let imageStr = padData.profilePic {
                let imageUrl = IMAGE_BASE_URL + imageStr
                self.employeeProfileImg.sd_setImage(with: URL(string:imageUrl), placeholderImage: #imageLiteral(resourceName: "dummy-user"))
            }
            editButton.isHidden = status == KPendingStatus ? false:true
            deleteButton.isHidden = status == KPendingStatus ? false:true
        }
    }
    
    func getDate(dateString:String) -> String{
        let separatedDate = dateString.split(separator: " ")
        let sepratedDateStr = separatedDate.first ?? ""
        return String(sepratedDateStr)
    }
    
    @IBAction func onTapEditButton(_ sender: Any) {
        delegate?.onTapEdit(cell: self,index: index)
    }
    
    @IBAction func onTapDeleteButton(_ sender: Any) {
        delegate?.onTapDelete(cell: self,index: index)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
