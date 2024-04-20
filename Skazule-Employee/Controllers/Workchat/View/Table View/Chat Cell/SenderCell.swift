//
//  SenderCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/27/23.
//

import UIKit
import SDWebImage

class SenderCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderPic: UIImageView!
    
    
    var userInfo:FirebaseUser1?{
        didSet{
            guard let userInfo = self.userInfo else {return}
            let userName = userInfo.userName
            senderName.text = userName
            let profileUrl = userInfo.profile ?? ""
            let imageUrl = URL(string: profileUrl)
           self.senderPic.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "profilePlaceHolder"))
            
        }
    }
    
    var message: Message2?{
        didSet{
            guard let message = self.message else { return }
            if message.timestamp != nil {
            let timeStamp = Date(timeIntervalSince1970: TimeInterval(message.timestamp!)! / 1000)
            self.lblTime.text = timeStamp.convertTimeInterval()
            self.lblDate.text = timeStamp.convertTimeInterval(format: "MMM d, yyyy")
            }
            self.lblMessage.text = message.content
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.roundRadius(options: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 30)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

