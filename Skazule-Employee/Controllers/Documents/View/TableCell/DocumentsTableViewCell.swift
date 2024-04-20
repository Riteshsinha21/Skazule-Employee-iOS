//
//  DocumentsTableViewCell.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/12/23.
//

import UIKit


protocol DocumentCellDelegate{
    func onTapDownloadDoc(cell:DocumentsTableViewCell)
}

class DocumentsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var docTypeImage: UIImageView!
    @IBOutlet weak var docNmeLabel: UILabel!
    @IBOutlet weak var sharedByLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var downLoadButton: UIButton!
    
    var delegate:DocumentCellDelegate?
    
    var documentData:DocumentsData?{
        didSet{
            guard let documentData = self.documentData else{return}
            
            guard let docName = documentData.documentName else{return}
            guard let sharedBy = documentData.sharedBy else{return}
            guard let createdAt = documentData.createdAt else{return}
            guard let fileType = documentData.fileType else{return}
            
            switch fileType {
            case Kxls: docTypeImage.image = UIImage(named: Kxls)
            case kpdf: docTypeImage.image = UIImage(named: kpdf)
            case Kxlsx: docTypeImage.image = UIImage(named: Kxlsx)
            case Kdoc: docTypeImage.image = UIImage(named: Kdoc)
            case Kdocx: docTypeImage.image = UIImage(named: Kdocx)
            case Ktxt: docTypeImage.image = UIImage(named: Ktxt)
            case Kjpeg: print(Kjpeg)
                        docTypeImage.image = UIImage(named: Kimage)
                        
            case kjpg: docTypeImage.image = UIImage(named: Kimage)
                       print(kjpg)
            case Kpng: docTypeImage.image = UIImage(named: Kimage)
                       print(Kpng)
            default: print("*****")
            }
            docNmeLabel.text = docName
            sharedByLabel.text = sharedBy
            createdAtLabel.text =  gmtToLocalDate(dateStr: createdAt) 
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
    
    @IBAction func onTapDownloadButton(_ sender: Any) {
        delegate?.onTapDownloadDoc(cell: self)
    }
}
