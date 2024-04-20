//
//  NotificationsTableViewCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/19/23.
//

import UIKit



class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var senderImgView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderTitleMsgLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var employeeCheckBoxBackView: UIView!
    @IBOutlet weak var employeeCheckBox: UIButton!
    
    var notificationData:NotificationsData?{
        didSet{
            guard let notificationData = self.notificationData else{return}
            
            print(notificationData)
        //    guard let senderName  = notificationData.name else{return}
      //      guard let profilePic = notificationData.profilePic else {return}
            guard let title = notificationData.title else {return}
            guard let message = notificationData.message else {return}
            guard let date = notificationData.createdAt else {return}
            let DateTimeStr = convertDateTime(dateStr: date)
            
            senderNameLabel.text = "From : Love"  //"\(senderName)"
            senderTitleMsgLabel.text = title
            messageLabel.text = message
            dateLabel.text = DateTimeStr
            
//            let imageUrl = IMAGE_BASE_URL + profilePic
//            senderImgView.sd_setImage(with: URL(string:imageUrl),  placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
//            employeeCheckBoxBackView.isHidden = isFrom == KNewChat ? true : false
//            print(isFrom)
//            print(employeeCheckBoxBackView.isHidden)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
