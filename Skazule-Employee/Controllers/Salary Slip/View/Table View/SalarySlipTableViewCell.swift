//
//  SalarySlipTableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/29/23.
//

import UIKit

class SalarySlipTableViewCell: UITableViewCell {
    
//MARK: IBOutlets
    
    @IBOutlet weak var basicPayLabel: UILabel!
    @IBOutlet weak var hraLabel: UILabel!
    @IBOutlet weak var specialAllowancesLabel: UILabel!
    @IBOutlet weak var otherPayLabel: UILabel!
    @IBOutlet weak var grossPayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
