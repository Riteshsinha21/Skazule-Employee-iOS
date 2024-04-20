//
//  RequestTimeOffPopUp.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/11/23.
//

import UIKit
import IQKeyboardManagerSwift
import APJTextPickerView


protocol cancelRequestTimeOffDelegate {
//    func alertFromCancelRequestTimeOffPopUp(Message: String)
    func removePopUp()
}
class RequestTimeOffPopUp: UIView {

    //MARK: IBOutlets
    
    @IBOutlet weak var timeOffTypeTextField: UITextField!
    
    @IBOutlet weak var timeOffTypeButton: UIButton!
    
    @IBOutlet weak var startDateTextField: APJTextPickerView!
    
    @IBOutlet weak var endDateTextField: APJTextPickerView!
    
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var reasonTextView: UITextView!
    
    // MARK: Variables
    
    var view: UIView!
    var delegate:cancelRequestTimeOffDelegate?
    var leaveTypeId = Int()
    var id = Int()
    var testStr = ""
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)

        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        IQKeyboardManager.shared.enable = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // use bounds not frame or it'll be offset
        view.frame = bounds
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        
        // APJTextPickerView
        self.startDateTextField.datePicker?.datePickerMode = .date
        self.startDateTextField.dateFormatter.dateFormat =  "yyyy-MM-dd"
        self.startDateTextField.datePicker?.minimumDate =  Date()
        self.endDateTextField.datePicker?.datePickerMode = .date
        self.endDateTextField.dateFormatter.dateFormat =  "yyyy-MM-dd"
        self.endDateTextField.datePicker?.minimumDate = Date()
        
        addSubview(view)
//        setUp()
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
 
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RequestTimeOffPopUp", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 140
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    @IBAction func onTapCancelBtn(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
