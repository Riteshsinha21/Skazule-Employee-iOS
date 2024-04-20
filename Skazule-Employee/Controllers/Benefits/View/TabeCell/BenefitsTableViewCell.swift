//
//  BenefitsTableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/10/23.
//

import UIKit

class BenefitsTableViewCell: UITableViewCell {

    @IBOutlet weak var premiumPayLabel: UILabel!
    @IBOutlet weak var employeePayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var companyPayLabel: UILabel!
    @IBOutlet weak var benefitsLabel: UILabel!
    
    var benefitsData:BenefitsData?{
        didSet{
            guard let benefitsData = self.benefitsData else{return}
            guard let premiumPay = benefitsData.premiumAmt else{return}
            guard let empPay = benefitsData.employeeAmt else{return}
            guard let companyPay = benefitsData.companyAmt else{return}
            guard let description = benefitsData.description else{return}
            guard let benefits = benefitsData.benefitName else{return}
            premiumPayLabel.text = "\(premiumPay)"
            employeePayLabel.text = "\(empPay)"
            companyPayLabel.text = "\(companyPay)"
            descriptionLabel.text = "\(description)"
            benefitsLabel.text = "\(benefits)"
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
