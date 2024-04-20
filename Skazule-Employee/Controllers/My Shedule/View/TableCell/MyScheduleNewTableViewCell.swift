//
//  MyScheduleNewTableViewCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 9/28/23.
//

import UIKit

class MyScheduleNewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var shiftTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(info:MySheduleData,index:Int){
        let checkInTimeStr = gmtToLocal(dateStr: info.checkIn ?? "")
        let checkOutTimeStr = gmtToLocal(dateStr: info.checkOut ?? "")
        shiftTimeLabel.text = "\(checkInTimeStr ?? "")-\(checkOutTimeStr ?? "")"
        dateLabel.text = info.date
        statusLabel.text = info.status == 0 ? KPendingStatus : KConfirmedStatus
        statusLabel.textColor = info.status == 0 ? UIColor.red : UIColor.systemGreen
    }
    
}
