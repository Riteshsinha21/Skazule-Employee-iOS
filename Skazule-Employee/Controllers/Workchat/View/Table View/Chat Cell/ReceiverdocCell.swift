//
//  ReceiverdocCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/27/23.
//

import UIKit

class ReceiverdocCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    var message: Message?{
        didSet{
            
            guard let message = self.message else { return }
            if message.timestamp != nil {
            let timeStamp = Date(timeIntervalSince1970: TimeInterval(message.timestamp!)! / 1000)
            self.lblTime.text = timeStamp.convertTimeInterval()
            self.lblDate.text = timeStamp.convertTimeInterval(format: "MMM d, yyyy")
            }
            self.lblMessage.text = message.content
         //   DOWNLOAD_IMAGE_BASE_URL +
          //  let url = message.content ?? ""
           // self.Images.sd_setImage(with: URL(string:  url ), placeholderImage: #imageLiteral(resourceName: "forgot pw_img"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.roundRadius(options: [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 30)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
