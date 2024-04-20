//
//  WorkChatTableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/30/23.
//

import UIKit

class WorkChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var employeeLeftSideImgView: UIImageView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeLastMsgLabel: UILabel!
    @IBOutlet weak var employeeCheckBoxBackView: UIView!
    @IBOutlet weak var employeeCheckBox: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    var myChatData:FBDChatRoom?{
        didSet{
            guard let myChatData = self.myChatData else{return}
            
            if myChatData.type != Kgroup{
            guard let eployeeName  = myChatData.meta2?.userName else{return}
            guard let lastMessageText = myChatData.lastMessageText else {return}
            guard let profilePic = myChatData.meta2?.profileImage else {return}
            guard let lastMessage = myChatData.lastMessage else {return}
                
                employeeNameLabel.text = "\(eployeeName)"
                employeeLastMsgLabel.text = "\(lastMessageText)"
            //    let imageUrl = IMAGE_BASE_URL + profilePic
                employeeLeftSideImgView.sd_setImage(with: URL(string:profilePic),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
                let dateStr = getDateTimeFromTimeStamp(timeStamp: Double(lastMessage) ?? 0.0)
                dateTimeLabel.text = dateStr
            }else{
                guard let eployeeName  = myChatData.meta?["title"] else{return}
                guard let lastMessageText = myChatData.lastMessageText else {return}
                guard let profilePic = myChatData.meta?["icon"] as? String else {return}
                guard let lastMessage = myChatData.lastMessage else {return}
                
                employeeNameLabel.text = "\(eployeeName)"
                employeeLastMsgLabel.text = "\(lastMessageText)"
            //    let imageUrl = IMAGE_BASE_URL + profilePic
                employeeLeftSideImgView.sd_setImage(with: URL(string:profilePic),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
                let dateStr = getDateTimeFromTimeStamp(timeStamp: Double(lastMessage) ?? 0.0)
                dateTimeLabel.text = dateStr
            }
           
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
