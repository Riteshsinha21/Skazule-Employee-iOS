//
//  DashboardSheduleCollectionViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/6/23.
//

import UIKit

protocol DashboardCollectionCellDelegate{
    func onTapView(cell:DashboardSheduleCollectionViewCell)
}

class DashboardSheduleCollectionViewCell: UICollectionViewCell {

//MARK: IBOutlets
    
    @IBOutlet weak var scheduleTimeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!

    var delegate:DashboardCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(info:OpenShift,index:Int){
        
        titleLbl.lineBreakMode = .byWordWrapping
        titleLbl.numberOfLines = 0
        let checkInTimeStr = gmtToLocal(dateStr: info.checkIn ?? "")
        let checkOutTimeStr = gmtToLocal(dateStr: info.checkOut ?? "")
        scheduleTimeLbl.text = "\(checkInTimeStr ?? "")-\(checkOutTimeStr ?? "")"
        
//        scheduleTimeLbl.text = "05:30PM - 06:30PM"
        titleLbl.text = info.position //"Meeting with..."
    }
}
