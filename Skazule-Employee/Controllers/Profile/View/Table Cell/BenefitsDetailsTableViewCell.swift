//
//  BenefitsDetailsTableViewCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 11/20/23.
//

import UIKit

class BenefitsDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var premiumPayLabel: UILabel!
    @IBOutlet weak var employeePayLabel: UILabel!
    @IBOutlet weak var companyPayLabel: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(info:BenefitsPlan,index:Int){
        if let premiumPay = info.premium_pay,let companyPay = info.company_pay,let employeePay = info.employee_pay{
        premiumPayLabel.text = "$\(premiumPay)"
        companyPayLabel.text = "$\(companyPay)"
        employeePayLabel.text = "$\(employeePay)"
        }
    }
}
