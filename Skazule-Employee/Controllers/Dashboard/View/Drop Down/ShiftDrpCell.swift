//
//  ShiftDrpCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/18/23.
//

import UIKit
import DropDown

class ShiftDrpCell: DropDownCell {

    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var shiftNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
