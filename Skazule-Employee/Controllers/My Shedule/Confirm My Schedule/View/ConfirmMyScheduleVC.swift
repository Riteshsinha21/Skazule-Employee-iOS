//
//  ConfirmMyScheduleVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/25/23.
//

import UIKit

class ConfirmMyScheduleVC: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var timeOutLabel: UILabel!
    @IBOutlet weak var unpaidBreak: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    
//MARK: VAriable
    var info:MySheduleData?
    var viewModel:ConfirmMyScheduleViewModeling?
    
// MARK: View Controller Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureNavigationBar()
        setUpViews()
       
    }
//MARK: Privatre functions
    
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "Confirm My Schedule"
        customNavigationBar.customRightBarButton.isHidden = true
    }
    private func setUp(){
        self.recheckVM()
    }
    func setUpViews(){
        let employeeName = getEmployeeName()
        self.nameLabel.text = employeeName
        self.dateLabel.text = info?.date
        self.timeInLabel.text = info?.checkIn
        self.timeOutLabel.text = info?.checkOut
        self.unpaidBreak.text = "\(String(describing: info?.breakDuration ?? 0))"
        self.textView.text = info?.note
        if let colorCode = info?.colorCode{
            let colorCodeStr = colorCode.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            let colorCodeArr = colorCodeStr.components(separatedBy: ",")
            let r = Double(colorCodeArr[0]) ?? 0.0
            let g = Double(colorCodeArr[1]) ?? 0.0
            let b = Double(colorCodeArr[2]) ?? 0.0
            let backColor = UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1)
            colorView.backgroundColor = backColor
        }
        confirmButton.isHidden =  info?.type == 1 ? false:true
    }
//MARK: Confirm Button Clicked
    
    @IBAction func confirmButtonTaped(_ sender: Any) {
        
        integrateConfirmMyScheduleApi()
    }
}
extension ConfirmMyScheduleVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ConfirmMyScheduleViewModel()
        }
    }
}
extension ConfirmMyScheduleVC{
    
    private func integrateConfirmMyScheduleApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_CONFIRM_SCHEDULE_API
        let employeeId = String(getEmployeeId())
        let userId = getUserId()
        let id =  "\(String(describing: info?.id ?? 0))"
        let param:[String:String] = [ "id":id,"user_id":"\(userId)"]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestConfirmMyScheduleApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var confirmMyScheduleResponse = ConfirmMyScheduleResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(ConfirmMyScheduleResponse.self, from: jsonData!)
                    print(responseData)
                    confirmMyScheduleResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
               strongSelf.processMySheduleResponse(receivedData: confirmMyScheduleResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processMySheduleResponse(receivedData:ConfirmMyScheduleResponse){

        if receivedData.status == 1{
            let message = receivedData.message ?? ""
                        showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
                        })
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
