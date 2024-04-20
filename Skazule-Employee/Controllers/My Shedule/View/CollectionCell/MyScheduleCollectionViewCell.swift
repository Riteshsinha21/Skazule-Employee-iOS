//
//  MyScheduleCollectionViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/20/23.
//

import UIKit

class MyScheduleCollectionViewCell: UICollectionViewCell {

//MARK: IBOutlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    
//MARK: Variables
    
    var currentWeekData: CurrentWeekStruct?{
        didSet{
            guard let currentWeekData = self.currentWeekData else { return }
            self.dateLabel.text = currentWeekData.date
            self.dayLabel.text = currentWeekData.day
            self.cellView.backgroundColor = currentWeekData.cellBackgroundColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
