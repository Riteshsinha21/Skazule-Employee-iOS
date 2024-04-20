//
//  BenefitDetailsVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/22/23.
//

import UIKit

class BenefitDetailsVC: UIViewController {
    
 //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var premiumPayLabel: UILabel!
    @IBOutlet weak var employeePayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var companyPayLabel: UILabel!
    @IBOutlet weak var benefitsLabel: UILabel!

    
//MARK: Variables
    
    var benefitsData:BenefitsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        configureNavigationBar()
    }
    
    //MARK: Private functions
    private  func setUpViews(){
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
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "Benefit Details"
        customNavigationBar.customRightBarButton.isHidden = true
//        customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
    }

   
}
