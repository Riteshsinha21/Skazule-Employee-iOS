//
//  EmployeeTableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/5/23.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    
//MARK: IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shiftStartTImeLabel: UILabel!
    @IBOutlet weak var shiftEndTimeLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
   
    @IBOutlet weak var shiftHoursLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var otHoursLabel: UILabel!
    @IBOutlet weak var shiftTypeLabel: UILabel!
    
    var shiftCheckIn:String?{
        didSet{
            guard let shiftCheckIn = self.shiftCheckIn else { return }
            let shiftCheckInStr = gmtToLocal(dateStr: shiftCheckIn)
            shiftStartTImeLabel.text = shiftCheckInStr
        }
    }
    var shiftCheckOut:String?{
        didSet{
            guard let shiftCheckOut = self.shiftCheckOut else { return }
            let shiftCheckOutStr = gmtToLocal(dateStr: shiftCheckOut)
            shiftEndTimeLabel.text = shiftCheckOutStr
        }
    }
    var employeeData:TimeTrackData?{
        didSet{
            guard let employeeData = self.employeeData else { return }
           
            let dateStr =  employeeData.date ?? "" //gmtToLocalDate(dateStr:employeeData.date ?? "" )
            if let checkInStr = gmtToLocalTime(dateStr: employeeData.checkIn ?? ""){
                checkInLabel.text = checkInStr
            }else{
                checkInLabel.text = "-"
            }
            if let checkOutStr = gmtToLocalTime(dateStr: employeeData.checkOut ?? ""){
                checkOutLabel.text = checkOutStr
            }else{
                checkOutLabel.text = "-"
            }
            if let shiftType = employeeData.shiftType{
                shiftTypeLabel.text = shiftType
            } else{
                shiftTypeLabel.text = "-"
            }
            if let shiftHours = employeeData.shiftHour{
                let shiftHr = Float(shiftHours)/60
                let formatted = String(format: "%.2f Hours", shiftHr)
                shiftHoursLabel.text = formatted
            } else{
                shiftHoursLabel.text = "-"
            }
            if let workingHoursStr = employeeData.workingHour{
                let workingHr = Float(workingHoursStr)/60
                let formatted = String(format: "%.2f Hours", workingHr)
                workingHoursLabel.text = formatted
            } else{
                workingHoursLabel.text = "-"
            }
            if let otHours = employeeData.overTime{
                let otgHr = Float(otHours)/60
                let formatted = String(format: "%.2f Hours", otgHr)
                otHoursLabel.text = formatted
            } else{
                otHoursLabel.text = "-"
            }
            dateLabel.text = dateStr
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
