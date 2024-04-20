//
//  DashboardVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/31/23.
//

import UIKit
import SwiftyJSON
import DropDown



class DashboardVC: UIViewController {
    
    
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBarDrawer: CustomNavigationBarForDrawer!
    @IBOutlet weak var dashboardScheduledCollectionView: UICollectionView!
   
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var breakHoursLabel: UILabel!
    @IBOutlet weak var dashboardOpenShiftCollectionView: UICollectionView!
   
    @IBOutlet weak var clockInButton: UIButton!
    @IBOutlet weak var clockOutButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    
    @IBOutlet weak var breake1CompleteLabel: UILabel!
    @IBOutlet weak var breake2CompleteLabel: UILabel!
    @IBOutlet weak var breake3CompleteLabel: UILabel!
    
    @IBOutlet weak var todaysShiftView: CardView!
    @IBOutlet weak var openShiftView: CardView!
    
    @IBOutlet weak var todaysOpenShiftLabel: UILabel!
    
    @IBOutlet weak var openShiftTodaysDateLabel: UILabel!
    
    @IBOutlet weak var todaysScheduleDateLabel: UILabel!
    
    @IBOutlet weak var todaysScheduleViewAllButton: UIButton!
    
    @IBOutlet weak var todaysOpenShiftViewAllButton: UIButton!
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    //MARK: VAriables
    var viewModelDashboard:DashboardViewModeling?
    var viewModelClockIn:ClockInViewModeling?
    var viewModelClockOut:ClockOutViewModel?
    var viewModelStartBreak:StartBreakViewModel?
    var shiftId = Int()
    var dropDownData = [String]()
    let dropDown = DropDown()
    var notificationsListRespose = NotificationsResponse()
    var dashboardResponse = DashBoardResponse()
    var viewModel:NotificationsViewModel?
    var openShiftData = [OpenShift]()
    var openShift:OpenSchedule?
    
    
    var isCheckIn:Bool = false{
        didSet{
            switch isCheckIn {
            case true : clockInButton.backgroundColor = UIColor.gray //setBackGroundColorGray()
            case false : clockInButton.backgroundColor = Color.appButtonBlueColor//setBackGroundColorBlue()
            }
        }
    }
    var isCheckOut:Bool = true{
            didSet{
                switch isCheckOut {
                case true : clockOutButton.backgroundColor = Color.appButtonBlueColor //
                            breakButton.setTitle("Start Break", for: .normal)
                case false : clockOutButton.backgroundColor = Color.appButtonBlueColor
                }
            }
    }
    var isBreakStart:String = KStart{
        didSet{
            switch isBreakStart {
            case KStart : breakButton.backgroundColor =  Color.appButtonBlueColor //setBackGroundColorBlue()
            case KEnd : breakButton.backgroundColor =  Color.appButtonBlueColor //setBackGroundColorBlue()
 //           case KEnd : breakButton.backgroundColor = UIColor.gray //setBackGroundColorGray()
//            case KAllOver : breakButton.backgroundColor = UIColor.red //setBackGroundColorRed()
            case KAllOver : breakButton.backgroundColor = UIColor.gray //setBackGroundColorGray()
                breakButton.isUserInteractionEnabled = false
            default: print("******")
            }
        }
    }
    
    
    let dashboardTopCellBackgroundColorsArr = [#colorLiteral(red: 0.3529411765, green: 0.5529411765, blue: 0.5607843137, alpha: 1), #colorLiteral(red: 0.862745098, green: 0.9333333333, blue: 0.937254902, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.8509803922, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.968627451, blue: 0.862745098, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.9215686275, blue: 0.8509803922, alpha: 1), #colorLiteral(red: 0.9803921569, green: 0.9254901961, blue: 0.5607843137, alpha: 1)]
    //let dashboardTopCellIconsArr = [#imageLiteral(resourceName: "scheduled"), #imageLiteral(resourceName: "currently_clocked_in"), #imageLiteral(resourceName: "currently_on_break"), #imageLiteral(resourceName: "unfilled_open_shifts"), #imageLiteral(resourceName: "employees_with_timeoff"), #imageLiteral(resourceName: "pending_shifts_request")]
    let dashboardTopCellTitleArr = ["Scheduled", "Currently Clocked In : 0", "Currently On Break : 0", "Unfilled Open Shift : 0", "Employees With Time Off : 0", "Pending Shift Requests : 0"]
    
    let dashboardTopCellTitleColorArr = [#colorLiteral(red: 0.3725490196, green: 0.3882352941, blue: 0.6196078431, alpha: 1), #colorLiteral(red: 0.3529411765, green: 0.5529411765, blue: 0.5607843137, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.231372549, blue: 0.2, alpha: 1), #colorLiteral(red: 0.5254901961, green: 0.7215686275, blue: 0.4823529412, alpha: 1), #colorLiteral(red: 0.7843137255, green: 0.5764705882, blue: 0.3568627451, alpha: 1), #colorLiteral(red: 0.4666666667, green: 0.4274509804, blue: 0.1568627451, alpha: 1)]
    let dashboardTopCelldetailArr = ["Today's Scheduled", "Time Tracker", "Time Tracker", "Details", "Time Off Request", "Pending Shift Requests"]
    
    //MARK: ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        stackView.isHidden = true
        self.integrateDashboardApi()
        self.configureNavigationBar()
        self.configureCollectionViews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Employee Clock In
    @IBAction func clockInButtonTaped(_ sender: Any) {
 //       self.integrateCheckInApi()
        print(isCheckIn)
        isCheckIn ? UIAlertController.showInfoAlertWithTitle("Message", message: kAlreadyCheckInMessage, buttonTitle: "Okay"):  self.integrateCheckInApi()
        
       
    }
    
    //MARK: Employee Clock Out
    @IBAction func clockOutButtonTaped(_ sender: Any) {
        print(isCheckIn)
        print(isCheckOut)
        isCheckOut ? UIAlertController.showInfoAlertWithTitle("Message", message: KAlreadyCheckoutMessage, buttonTitle: "Okay") :  self.integrateCheckOutApi()
    }
    
    //MARK: Employee Start Break
    
    @IBAction func startBreakButtonTaped(_ sender: Any) {
        isCheckIn && !isCheckOut ? self.intetegrateStartBreakApi() : UIAlertController.showInfoAlertWithTitle("Message", message: KNotCheckedInMessage, buttonTitle: "Okay")
    }
    
  //MARK: View All Open Shifts
    
    @IBAction func ViewAllButtonTaped(_ sender: Any) {
        let vc = TodaysOpenShiftListVC()
        vc.todaysOpenShiftArr = self.openShiftData
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBarDrawer.titleLabel.text = "Dashboard"
        customNavigationBarDrawer.rightBtn.isHidden = true
        customNavigationBarDrawer.rightBtn.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
        customNavigationBarDrawer.notificationView.isHidden = true
        // Register to receive notification count
    //    NotificationCenter.default.addObserver(self, selector: #selector(openNotification(_:)), name: NSNotification.Name(rawValue: NOTIFICATION_KEYS.NOTIFICATION_COUNT), object: nil)
        
    }
    private func configureCollectionViews(){
        self.dashboardScheduledCollectionView.delegate = self
        self.dashboardScheduledCollectionView.dataSource = self
        self.dashboardOpenShiftCollectionView.delegate = self
        self.dashboardOpenShiftCollectionView.dataSource = self
        
        dashboardScheduledCollectionView.register(UINib(nibName: "DashboardSheduleCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DashboardSheduleCollectionViewCell")
        
        dashboardOpenShiftCollectionView.register(UINib(nibName: "DashboardSheduleCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DashboardSheduleCollectionViewCell")
    }
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        vc.notificationsListRespose = customNavigationBarDrawer.notificationsListRespose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Notification selector
    @objc func openNotification(_ notification: Notification){
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            print(dict)
            if let notificationCount = dict["notificationCount"] as? Int {
                print(notificationCount)
                customNavigationBarDrawer.notificationCountLabel.text = "\(notificationCount)"
            }
        }
    }
}
//MARK: Integrate Dashboard API

extension DashboardVC{
    
     func integrateDashboardApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_DASHBOARD_DATA
        let employeeId = String(getEmployeeId())
        let param:[String:String] = [ "employee_id":employeeId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModelDashboard?.requestDashboardApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
              
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(DashBoardResponse.self, from: jsonData!)
//                    print(responseData)
                    self?.dashboardResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processDashboarResponse(receivedData: self!.dashboardResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
        func processDashboarResponse(receivedData:DashBoardResponse){
            if receivedData.status == 1{
                  let message = receivedData.message ?? ""
        //******** For Check In data *******************************************
                
               
                let checkInData = receivedData.data?.chekinData
                if checkInData?.count != 0{
                    todaysShiftView.isHidden = true
                for item in checkInData ?? []{
 //                   if item.checkIn != nil{
 //                     isCheckIn = true
                    self.shiftId = item.shiftID ?? 0
                    isCheckIn = item.checkIn != nil ? true : false
                    isCheckOut = item.checkOut != nil ? true : false
                    if isCheckOut{
                        resetData()
                    }else{
                        let checkIn = item.checkIn ?? "0"
                        let checkInTimeStr = gmtToLocalTime(dateStr: checkIn) ?? "0"
                        self.checkInLabel.text = "Check In : \(checkInTimeStr)"
                        let checkOut = item.checkOut ?? "0"
                        let checkOutTimeStr = gmtToLocalTime(dateStr: checkOut) ?? "0"
                        self.checkOutLabel.text =  "Check Out : \(checkOutTimeStr)"
                        
                        let break1Duration = item.breake1Duration ?? 0
                        let break2Duration = item.breake2Duration ?? 0
                        let break3Duration = item.breake3Duration ?? 0
                        let breakTime = break1Duration + break2Duration + break3Duration
//                        let breakTime = "\(String(describing: item.breake1Duration ?? 0))"
                        self.breakHoursLabel.text = "Break Hours : \(breakTime) Minutes"
                    
                    if checkIn != KZero && checkOut == KZero{
                        isCheckIn = true
                    }else if checkIn != KZero && checkOut != KZero{
                        isCheckIn = false
                    }
                    
                    print(isBreakStart)
                    
                    if item.break1Start == nil{
                        breakButton.setTitle("Break 1 Start", for: .normal)
                        isBreakStart = KStart
                    }else if item.break1End == nil{
                        breakButton.setTitle("Break 1 End", for: .normal)
                        isBreakStart = KEnd
                    }else if item.break2Start == nil{
                        breakButton.setTitle("Break 2 start", for: .normal)
                        isBreakStart = KStart
                        breake1CompleteLabel.text = "Break 1 completed"
                    }else if item.break2End == nil{
                        breakButton.setTitle("Break 2 End", for: .normal)
                        isBreakStart = KEnd

                    }else if  item.break3Start == nil{
                        breakButton.setTitle("Break 3 start", for: .normal)
                        breake1CompleteLabel.text = "Break 1 completed"
                        breake2CompleteLabel.text = "Break 2 completed"
                        isBreakStart = KStart
                    }else if item.break3End == nil{
                        breakButton.setTitle("Break 3 End", for: .normal)
                        isBreakStart = KEnd
                    }else{
                        breake1CompleteLabel.text = "Break 1 completed"
                        breake2CompleteLabel.text = "Break 2 completed"
                        breake3CompleteLabel.text = "Break 3 completed"
                        breakButton.setTitle("Break Over", for: .normal)
                        isBreakStart = KAllOver

                    }
                    }
                }
                }else{
                    todaysShiftView.isHidden = true
                }
 //******** For open shift data *******************************************
                if let openShiftData = receivedData.data?.openShift{
                    self.openShiftData = openShiftData
                }
                if self.openShiftData.count != 0{
                    openShiftView.isHidden = false
                    todaysOpenShiftLabel.text = "Todays's Open Shift (\(self.openShiftData.count))"
                    openShiftTodaysDateLabel.text =  selectedDate(selectDate: Date())

                    dashboardOpenShiftCollectionView.reloadData()

                }else{
                    openShiftView.isHidden = true
                }
                    todaysOpenShiftViewAllButton.isHidden = self.openShiftData.count < 6 ? true : false
            }else{
                self.isCheckIn = false
                let message = receivedData.message
              //  UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
            }
        }
    
    
//    func processDashboarResponse(receivedData:DashBoardResponse){
//        if receivedData.status == 1{
//            let message = receivedData.message ?? ""
//            let checkIn = "\(String(describing: receivedData.data?[0].checkIn ?? "0"))"
//            let checkInTimeStr = gmtToLocalTime(dateStr: checkIn) ?? "0"
//            let checkOut = "\(String(describing: receivedData.data?[0].checkOut ?? "0"))"
//            let checkOutTimeStr = gmtToLocalTime(dateStr: checkOut) ?? "0"
//            self.checkInLabel.text = "Check In : \(checkInTimeStr)"
//            self.checkOutLabel.text =  "Check Out : \(checkOutTimeStr)"
//            self.shiftId = receivedData.data?[0].shiftID ?? 0
//            let breakTime = "\(String(describing: receivedData.data?[0].breake1Duration ?? 0))"
//            self.breakHoursLabel.text = "Break Hours : \(breakTime) Minutes"
//
//            if checkIn != KZero && checkOut == KZero{
//                isCheckIn = true
//            }else if checkIn != KZero && checkOut != KZero{
//                isCheckIn = false
//            }
//
//
//            print(isBreakStart)
//
//            if receivedData.data?[0].break1Start == nil{
//                breakButton.setTitle("Break 1 Start", for: .normal)
//                isBreakStart = KStart
//            }else if receivedData.data?[0].break1End == nil{
//                breakButton.setTitle("Break 1 End", for: .normal)
//                isBreakStart = KEnd
//            }else if receivedData.data?[0].break2Start == nil{
//                breakButton.setTitle("Break 2 start", for: .normal)
//                isBreakStart = KStart
//                breake1CompleteLabel.text = "Break 1 completed"
//            }else if receivedData.data?[0].break2End == nil{
//                breakButton.setTitle("Break 2 End", for: .normal)
//                isBreakStart = KEnd
//
//            }else if  receivedData.data?[0].break3Start == nil{
//                breakButton.setTitle("Break 3 start", for: .normal)
//                breake1CompleteLabel.text = "Break 1 completed"
//                breake2CompleteLabel.text = "Break 2 completed"
//                isBreakStart = KStart
//            }else if receivedData.data?[0].break3End == nil{
//                breakButton.setTitle("Break 3 End", for: .normal)
//                isBreakStart = KEnd
//            }else{
//                breake1CompleteLabel.text = "Break 1 completed"
//                breake2CompleteLabel.text = "Break 2 completed"
//                breake3CompleteLabel.text = "Break 3 completed"
//                breakButton.setTitle("All Over", for: .normal)
//                isBreakStart = KAllOver
//
//            }
//        }else{
//            self.isCheckIn = false
//            let message = receivedData.message
//          //  UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
//        }
//    }
}
extension DashboardVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModelDashboard == nil {
            self.viewModelDashboard = DashboardViewModel()
        }
        if self.viewModelClockIn == nil {
            self.viewModelClockIn = ClockInViewModel()
        }
        if self.viewModelClockOut == nil {
            self.viewModelClockOut = ClockOutViewModel()
        }
        if self.viewModelStartBreak == nil {
            self.viewModelStartBreak = StartBreakViewModel()
        }
    }
}
//MARK: Collection View Data Source and Delegate
extension DashboardVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let openShiftData = dashboardResponse.data?.openShift
//        if let openShiftCount = openShiftData?.count{
//          return openShiftCount
//        }else{
//            return 0
//        }
        return self.openShiftData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardSheduleCollectionViewCell", for: indexPath) as? DashboardSheduleCollectionViewCell else{ return UICollectionViewCell()}
        
        guard let info = dashboardResponse.data?.openShift?[indexPath.row] else {return UICollectionViewCell()}
        cell.configureCell(info: info, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 3 - 5
        let cellHeight = collectionView.frame.size.height / 2 
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ViewOpenShiftVC()
        
        let info = self.openShiftData[indexPath.row]
        
        let openShift = OpenSchedule.init(nubmerOfOpening: info.nubmerOfOpening, scheduleID: info.scheduleID, checkOut: info.checkOut, colorCode: info.colorCode, note: info.note, nubmerOfAssignedOpening: info.nubmerOfAssignedOpening, checkIn: info.checkIn, restOpening: 0, date: info.date, shiftName: info.shiftName, breakDuration: info.breakDuration, position: info.position,tags: info.tags)

        
 //       print(info)
        
//        let status = self.schedulerRsponse.status
        vc.info = openShift
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
