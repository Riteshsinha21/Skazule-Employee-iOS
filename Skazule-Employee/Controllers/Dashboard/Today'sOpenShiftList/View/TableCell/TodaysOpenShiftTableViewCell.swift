//
//  TodaysOpenShiftTableViewCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 9/27/23.
//

import UIKit

class TodaysOpenShiftTableViewCell: UITableViewCell {

    
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onTapViewButton(_ sender: Any) {
        
        
    }
    func configureCell(info:OpenShift,index:Int){
        
        positionLabel.lineBreakMode = .byWordWrapping
        positionLabel.numberOfLines = 0
        let checkInTimeStr = gmtToLocal(dateStr: info.checkIn ?? "")
        let checkOutTimeStr = gmtToLocal(dateStr: info.checkOut ?? "")
        scheduleTimeLabel.text = "\(checkInTimeStr ?? "")-\(checkOutTimeStr ?? "")"
        
//        scheduleTimeLbl.text = "05:30PM - 06:30PM"
        positionLabel.text = info.position //"Meeting with..."
    }
}
