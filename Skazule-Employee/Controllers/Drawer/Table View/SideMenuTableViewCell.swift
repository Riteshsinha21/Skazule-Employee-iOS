//
//  SideMenuTableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/10/23.
//

import UIKit

protocol SideMenuTableCellDelegate{
    
//    func congigureCell(cell: SideMenuTableViewCell)
    
}

class SideMenuTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var sideIconImage:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    
  //MARK: Variables
    
    var delegate:SideMenuTableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func congigureCell(_menuName:String,_sideImage:UIImage){
        sideIconImage.image = _sideImage //UIImage(named: "profilePlaceHolder")    
        titleLabel.text = _menuName
 //       delegate?.congigureCell(cell: self)
    }
//    func setupCell(_data:DataObject) {
//        // update layout depending on data
//        itemNo.text = _data.document_no
//        itemPrice.text = _data.sum
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
