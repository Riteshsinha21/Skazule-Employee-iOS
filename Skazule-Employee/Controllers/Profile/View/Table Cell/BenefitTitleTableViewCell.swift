//
//  BenefitTitleTableViewCell.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 11/17/23.
//

import UIKit




class BenefitTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var benefitTitleLabel: UILabel!
    @IBOutlet weak var dropDownImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell(info:CellData,index:Int){
     benefitTitleLabel.text = info.title
        if info.isOpened == false{
           dropDownImage.image =  UIImage(systemName: "chevron.down")
        }else{
          dropDownImage.image =  UIImage(systemName: "chevron.up")
        }
    }
}
