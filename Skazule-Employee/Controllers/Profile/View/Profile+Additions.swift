//
//  Profile+Additions.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 10/4/23.
//

import Foundation
import UIKit
import CountryPickerView

extension ProfileVC{
    
    func showAddProfilePicPopup(){
        self.customChooseImgView = CustomChooseImgView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.customChooseImgView.cameraButton.addTarget(self, action: #selector(self.cameraButtonPressed), for: .touchUpInside)
        self.customChooseImgView.gallaryButton.addTarget(self, action: #selector(self.gallaryButtonPressed), for: .touchUpInside)
        self.view.addSubview(self.customChooseImgView)
    }
    @objc func cameraButtonPressed(sender: UIButton) {
        self.customChooseImgView.removeFromSuperview()
        self.openCamera()
    }
    @objc func gallaryButtonPressed(sender: UIButton) {
        self.customChooseImgView.removeFromSuperview()
        self.openGallery()
    }
}
extension ProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Opening camera
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // Opening Gallery
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK:- imagePickerController delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.profilePic.image = pickedImage
            saveImageDocumentDirectory(usedImage: pickedImage)
        }
        if let imgUrl = getImageUrl()
        {
            pickedImageUrl = imgUrl
        }
        dismiss(animated: true, completion: nil)
    }
}
extension ProfileVC:CountryPickerViewDelegate{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        selectedCountryCode = country.phoneCode
        print(selectedCountryCode)
    }
}
