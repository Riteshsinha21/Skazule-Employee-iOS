//
//  SchedulerTableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/27/23.
//

import UIKit

class SchedulerTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var shiftNmeLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var cellUpperView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    //MARK: Variables

    var openScheduleData:OpenSchedule?{
        didSet{
            guard let openScheduleData = self.openScheduleData else { return }
            //     shiftNmeLabel.text = myscheduleData.shiftName ?? ""
            
            if let colorCode = openScheduleData.colorCode{
                let colorCodeStr = colorCode.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                let colorCodeArr = colorCodeStr.components(separatedBy: ",")
                let r = Double(colorCodeArr[0]) ?? 0.0
                let g = Double(colorCodeArr[1]) ?? 0.0
                let b = Double(colorCodeArr[2]) ?? 0.0
                let backColor = UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1)
                
                cellBackgroundView.backgroundColor = backColor
            }
            let checkInTimeStr = gmtToLocal(dateStr: openScheduleData.checkIn ?? "")
            let checkOutTimeStr = gmtToLocal(dateStr: openScheduleData.checkOut ?? "")
            shiftNmeLabel.text = "\(checkInTimeStr ?? "")-\(checkOutTimeStr ?? "")"
            
            let checkInStr = openScheduleData.checkIn ?? ""
            let dateStr = openScheduleData.date ?? ""
            let dateWithTimeStr = dateStr + " " + checkInStr
            print(dateWithTimeStr)
            guard let dateStrLocal = gmtToLocalDate(dateStr: dateWithTimeStr) else{return}
            print(dateStr)
        
//            dateLabel.text = openScheduleData.date ?? ""
            dateLabel.text = dateStrLocal
            positionLabel.text = openScheduleData.position ?? ""
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
