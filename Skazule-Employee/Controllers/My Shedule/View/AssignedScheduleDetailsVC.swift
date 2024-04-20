//
//  AssignedScheduleDetailsVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 9/29/23.
//

import UIKit

class AssignedScheduleDetailsVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var noOfopeningLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var restOpeningLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shiftStartTimeLabel: UILabel!
    @IBOutlet weak var shiftEndTimeLabel: UILabel!
    @IBOutlet weak var breakDurationLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var shiftNoteLabel: UILabel!
    
    //MARK: VAriables
    var isFrom = "" //KRequestedSchedule
    var scheduleId = Int()
    var status = Int()
    var id = Int()
    // For Tags
    var tagsViewModel:TagsViewModel?
    var tagsArr =  [String]()
    //For Position
    var positionViewModel:PositionViewModel?
    var position = ""
    let dispatchGroup = DispatchGroup()
    var viewModelScheduleEdit:ScheduleEditViewModel?
    var scheduleEditResponse = ScheduleEditResponse()
    // For Confirm Schedule
    var viewModel:ConfirmMyScheduleViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        configureNavigationBar()
        // Call first Api
        setUpConfirmButton()
        integrateScheduleEditApi()
 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 //       configureNavigationBar()
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        print(isFrom)
        self.customNavigationBar.titleLabel.text = isFrom == KRequestedSchedule ? KRequestedSchedule : KAssignedSchedule
        customNavigationBar.customRightBarButton.isHidden = true
        
    }
    //MARK: Setup Confirm Button
    
    func setUpConfirmButton(){
        confirmButton.isHidden =  isFrom == KAssignedSchedule ? false:true
        if isFrom == KRequestedSchedule{
            confirmButton.isHidden = true
        }else if status == Int(KOne){
            confirmButton.isHidden = true
        }else{
            let date = scheduleEditResponse.data?.date ?? ""
            let checkIn =  scheduleEditResponse.data?.checkIn ?? ""
            let checkOut =  scheduleEditResponse.data?.checkOut ?? ""
            let dateString = date + " " + checkIn
            let convertedLocalDateStr = gmtToLocalDate(dateStr: dateString)
            let convertedLocalCheckInStr = gmtToLocal(dateStr: checkIn)
            let convertedLocalCheckOutStr = gmtToLocal(dateStr: checkOut)
            
            let currentDateStr  = Date().toString(dateFormat: "yyyy-MM-dd")
            let currentTimeStr  = Date().toString(dateFormat: "h:mm a")
            
            
            if (currentDateStr > convertedLocalDateStr ?? "\(currentDateStr)"){
                confirmButton.isHidden = true
            }else if (currentDateStr == convertedLocalDateStr ?? "\(currentDateStr)") && (isTimeCompareFromCurrentTime(currentTimeStr: currentTimeStr, timeIn: convertedLocalCheckInStr ?? "\(currentTimeStr)") == false){
                 confirmButton.isHidden = false
         }
        }
    }
    //MARK: Confirm Button Taped
    
    @IBAction func confirmButtonTaped(_ sender: Any) {
        
        integrateConfirmMyScheduleApi()
    }
  //MARK: Setup data
    func setUpData(receivedData:ScheduleEditResponse){
        confirmedLabel.text = "\(status)"
        let noOfopening = receivedData.data?.nubmerOfOpening ?? 0
        let noOfassignedOpening = receivedData.data?.nubmerOfAssignedOpening ?? 0
        let restOpening = noOfopening - noOfassignedOpening
        let date = receivedData.data?.date ?? ""
        let breakDuration = receivedData.data?.breakDuration ?? 0
        noOfopeningLabel.text = "\(noOfopening)"
        restOpeningLabel.text = "\(restOpening)"
        dateLabel.text =  date
        shiftStartTimeLabel.text = gmtToLocal(dateStr: receivedData.data?.checkIn ?? "")
        shiftEndTimeLabel.text = gmtToLocal(dateStr: receivedData.data?.checkOut ?? "")
        breakDurationLabel.text = "\(breakDuration)"
        shiftNoteLabel.text = receivedData.data?.note
//        tagLabel.text = receivedData.data?.tags
        positionLabel.text = position
    }
}
extension AssignedScheduleDetailsVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModelScheduleEdit == nil {
            self.viewModelScheduleEdit = ScheduleEditViewModel()
        }
        if self.tagsViewModel == nil {
            self.tagsViewModel = TagsViewModel()
        }
        if self.positionViewModel == nil {
            self.positionViewModel = PositionViewModel()
        }
        if self.viewModel == nil {
            self.viewModel = ConfirmMyScheduleViewModel()
        }
    }
}
extension AssignedScheduleDetailsVC{
    private func integrateScheduleEditApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_SCHEDULE_EDIT_API
        let employeeId = String(getEmployeeId())
        let param = ["schedule_id":scheduleId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModelScheduleEdit?.requestScheduleEditApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
//                var scheduleEditResponse = ScheduleEditResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(ScheduleEditResponse.self, from: jsonData!)
                    self?.scheduleEditResponse = responseData
                }catch let error{
            //        print(error.localizedDescription)
                    print(error)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processResponse()
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process Update Profile Response
    
    func processResponse(){
        
        if scheduleEditResponse.status == 1{
            integratePositionApi()
 //         setUpData(receivedData: scheduleEditResponse)
        }else{
            let message = scheduleEditResponse.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
extension AssignedScheduleDetailsVC{
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
                
                if scheduleEditResponse.data?.tags?.count != 0{
                    for item in scheduleEditResponse.data?.tags ?? []{
                        if let tagId = tags?.first(where: {$0.id == Int(item)}){
                            openShiftTags.append(tagId)
                        }
                    }
                    let tagsArr = openShiftTags.map({$0.tag})
                    print(tagsArr)
                    self.tagLabel.text = tagsArr.joined(separator: ",")
                    
                }else{
                    tagLabel.text = ""
                }
                setUpData(receivedData: scheduleEditResponse)
            }else{
                let message = receivedData.message
                UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
            }
    }
}
extension AssignedScheduleDetailsVC{
        private func integratePositionApi(){
            
            let fullUrl = BASE_URL + PROJECT_URL.GET_COMPANY_POSITIONS_API
            let companyId = String(getCompanyId())
            
            let param:[String:Any] = [ "company_id": companyId]
            
            print(param)
            if Reachability.isConnectedToNetwork() {
                // showProgressOnView(appDelegateInstance.window!)
                showProgressOnView(self.view)
                self.tagsViewModel?.requestTagsApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                    print(receivedData)
                    hideAllProgressOnView(self!.view)
                    var positionResponse = PositionResponse()
                    do{
                        let jsonData = self?.getDataFrom(JSON: receivedData)
     //                   print(String(data: jsonData!, encoding: .utf8)!)
                        let responseData = try JSONDecoder().decode(PositionResponse.self, from: jsonData!)
     //                   print(responseData)
                        positionResponse = responseData
                    }catch let error{
                        print(error.localizedDescription)
                    }
                    guard let strongSelf = self else { return }
                    
                    strongSelf.processPositionResponse(receivedData: positionResponse)
                })
            }else{
                showLostInternetConnectivityAlert()
            }
        }
        func processPositionResponse(receivedData:PositionResponse){
            
            if receivedData.status == 1{
                integrateTagsApi()
                
                if let positionId = scheduleEditResponse.data?.positionID{
                    if positionId != 0{
                     let item  = receivedData.data?.filter{$0.id == positionId}
//                     if let position = item?[0].position{
//                        self.positionLabel.text = position
//                     }
                        position = item?[0].position ?? ""
                    }else{
                        positionLabel.text = ""
                    }
                }
            }else{
                let message = receivedData.message
                UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
            }
    }
}
extension AssignedScheduleDetailsVC{
    
    private func integrateConfirmMyScheduleApi(){

        let fullUrl = BASE_URL + PROJECT_URL.GET_CONFIRM_SCHEDULE_API
        let employeeId = String(getEmployeeId())
        let userId = getUserId()
//        let id =  "\(String(describing: info?.id ?? 0))"
        let param:[String:String] = [ "id":"\(id)","user_id":"\(userId)"]

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
