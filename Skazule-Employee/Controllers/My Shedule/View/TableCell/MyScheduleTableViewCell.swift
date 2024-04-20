//
//  MyScheduleTableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/20/23.
//

import UIKit

class MyScheduleTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var shiftNmeLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var cellUpperView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var approvedImage: UIImageView!
    
    
    //MARK: Variables

    var myscheduleData:MySheduleData?{
        didSet{
            guard let myscheduleData = self.myscheduleData else { return }
           
           print(myscheduleData)
            if let colorCode = myscheduleData.colorCode{
                let colorCodeStr = colorCode.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                let colorCodeArr = colorCodeStr.components(separatedBy: ",")
                let r = Double(colorCodeArr[0]) ?? 0.0
                let g = Double(colorCodeArr[1]) ?? 0.0
                let b = Double(colorCodeArr[2]) ?? 0.0
                let backColor = UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1)
                
                cellBackgroundView.backgroundColor = backColor
            }
            if let status = myscheduleData.status{
                if status == 1{
                    approvedImage.isHidden = false
                    approvedImage.image = UIImage(named: "approved")
                }else{
                    approvedImage.isHidden = true
                }
            }
            let checkInTimeStr = gmtToLocal(dateStr: myscheduleData.checkIn ?? "")
            let checkOutTimeStr = gmtToLocal(dateStr: myscheduleData.checkOut ?? "")
    
            shiftNmeLabel.text = "\(checkInTimeStr ?? "")-\(checkOutTimeStr ?? "")"
            dateLabel.text = myscheduleData.date ?? ""
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
