//
//  ViewOpenShiftVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/1/23.
//

import UIKit

class ViewOpenShiftVC: UIViewController {
    
    
    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var timeOutLabel: UILabel!
    @IBOutlet weak var unpaidBreak: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var noOfOpeningLabel: UILabel!
    //MARK: VAriable
    
    
    var info: OpenSchedule?
    var viewModel:OpenShiftVeiwModel?
    var tagsViewModel:TagsViewModel?
    var tagsArr =  [String]()
    
    // MARK: View Controller Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureNavigationBar()
        setUpViews()
        integrateTagsApi()
    }
    //MARK: Privatre functions
    
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "View Open Shift"
        customNavigationBar.customRightBarButton.isHidden = true
    }
    private func setUp(){
        self.recheckVM()
    }
    func setUpViews(){
        let employeeName = getEmployeeName()
        textView.isUserInteractionEnabled = false
        self.nameLabel.text = employeeName
        self.noOfOpeningLabel.text = "\(String(describing:info?.nubmerOfOpening ?? 0))"
        self.dateLabel.text = info?.date
        
        let checkInTimeStr = gmtToLocal(dateStr: info?.checkIn ?? "")
        let checkOutTimeStr = gmtToLocal(dateStr: info?.checkOut ?? "")
        
        self.timeInLabel.text = checkInTimeStr
        self.timeOutLabel.text = checkOutTimeStr
        self.unpaidBreak.text = "\(String(describing: info?.breakDuration ?? 0))"
        self.positionLabel.text =  info?.position
        self.tagLabel.text = "NA"
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
    }
    //MARK: Add Button Clicked
    @IBAction func applyButtonTaped(_ sender: Any) {
        integrateApplyScheduleApi()
    }
}
extension ViewOpenShiftVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = OpenShiftVeiwModel()
        }
        if self.tagsViewModel == nil {
            self.tagsViewModel = TagsViewModel()
        }
    }
}
//MARK: Integrate Apply for Schedule Api
extension ViewOpenShiftVC{
    private func integrateApplyScheduleApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_APPLYFORSCHEDULE_API
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        let userId = String(getUserId())
        guard let schedulId =  info?.scheduleID else{ return}
        let param:[String:String] = ["employee_id":employeeId,"company_id":companyId,"user_id":userId,"schedule_id": "\(String(describing: schedulId))" ]
        
        //company_id:217
        //    user_id:444
        //    employee_id:176
        //    schedule_id:29"
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestOpenShiftApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
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
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}

//MARK: Integrate Tags Api
extension ViewOpenShiftVC{
    private func integrateTagsApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_COMPANY_TAGS_API
        let companyId = String(getCompanyId())
        
        let param:[String:Any] = [ "company_id": companyId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.tagsViewModel?.requestTagsApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var tagsResponse = TagsResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
 //                   print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(TagsResponse.self, from: jsonData!)
 //                   print(responseData)
                    tagsResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processTagsResponse(receivedData: tagsResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processTagsResponse(receivedData:TagsResponse){
        
        if receivedData.status == 1{
            let tags = receivedData.data
            var openShiftTags = [TagsData]()
            
            if info?.tags?.count != 0{
                for item in info?.tags ?? []{
                    if let tagId = tags?.first(where: {$0.id == Int(item)}){
                        openShiftTags.append(tagId)
                    }
                }
                let tagsArr = openShiftTags.map({$0.tag})
                print(tagsArr)
                self.tagLabel.text = tagsArr.joined(separator: ",")
            }
            //        let message = receivedData.message ?? ""
            //                    showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
            //                        self.navigationController?.popViewController(animated: true)
            //                    })
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
