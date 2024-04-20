//
//  WorkChatEmployeeListCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/21/23.
//

import UIKit

class WorkChatEmployeeListCell: UITableViewCell {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var employeeLeftSideImgView: UIImageView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeLastMsgLabel: UILabel!
    @IBOutlet weak var employeeCheckBoxBackView: UIView!
    @IBOutlet weak var employeeCheckBox: UIButton!

    var isFrom = ""
    var employeeData:EmployeeListData?{
        didSet{
            guard let employeeData = self.employeeData else{return}
            guard let eployeeName  = employeeData.name else{return}
            guard let lastMessage = employeeData.email else {return}
            guard let profilePic = employeeData.profilePic else {return}

            employeeNameLabel.text = "\(eployeeName)"
            employeeLastMsgLabel.text = "\(lastMessage)"
            let imageUrl = IMAGE_BASE_URL + profilePic
            employeeLeftSideImgView.sd_setImage(with: URL(string:imageUrl),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
            employeeCheckBoxBackView.isHidden = isFrom == KNewChat ? true : false
            print(isFrom)
            print(employeeCheckBoxBackView.isHidden)
        }
    }

    var empFirebaseData:FirebaseUser1?{
        didSet{
            guard let employeeData = self.empFirebaseData else{return}
            guard let eployeeName  = employeeData.userName else{return}
            guard let profilePic = employeeData.profile else {return}

            employeeNameLabel.text = "\(eployeeName)"
            employeeLastMsgLabel.text = ""
            employeeLeftSideImgView.sd_setImage(with: URL(string:profilePic),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
            employeeCheckBoxBackView.isHidden;employeeLastMsgLabel.isHidden = true //isFrom == KNewChat ? true : false
            print(isFrom)
            print(employeeCheckBoxBackView.isHidden)
        }
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
