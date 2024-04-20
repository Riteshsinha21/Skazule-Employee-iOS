//
//  ProfileVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/19/23.
//



import UIKit
import CountryPickerView

protocol ProfileUpdateDelegate: AnyObject {
    func profileDidUpdate(updatedData: [String:String])
}



class ProfileVC: UIViewController {
        
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    
    @IBOutlet weak var outerView: UIView!{
        didSet{
            outerView.layer.cornerRadius = outerView.frame.height/2
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            profileImage.layer.cornerRadius = profileImage.frame.height/2
        }
    }
    @IBOutlet weak var profilePic: UIImageView!{
        didSet{
            profilePic.layer.cornerRadius = profilePic.frame.height/2
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var shiftLabel: UILabel!
    @IBOutlet weak var breakLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var benifitsLabel: UILabel!
    @IBOutlet weak var reportingLabel: UILabel!
    @IBOutlet weak var weakLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var maxHoursLabel: UILabel!
    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var employeeId: UILabel!
    @IBOutlet weak var countryPickerView: CountryPickerView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: VAriables
    var viewModel: ProfileViewModel?
    var viewModelUpdateProfile:UpdateProfileViewModel?
    let imagePicker = UIImagePickerController()
    var pickedImage : UIImage!
    var pickedImageUrl:URL?
    //Custom Alert View
    var customChooseImgView : CustomChooseImgView!
    var cpv = CountryPickerView()
    var selectedCountryCode = String()
    var benefits = [Benefit]()
    var benefitsData = [CellData]()
    
    weak var delegate: ProfileUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.integrateProfileApi()
        self.configureNavigationBar()
        self.configureCountryPicker()
        self.configureTableView()
        self.editProfileView.isHidden = true
        self.emailTextField.delegate = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "Profile"
        customNavigationBar.customRightBarButton.isHidden = false
        //       customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
        
        self.customNavigationBar.customRightBarButton.setImage(UIImage(named: "edit_icon"), for: .normal)
        self.customNavigationBar.customRightBarButton.addTarget(self, action: #selector(onTapEditProfileButton), for: .touchUpInside)
    }
    private func configureCountryPicker(){
        
        //        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        //        cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        //        cpv.delegate = self
        //        cpv.showPhoneCodeInView = true
        //        cpv.showCountryCodeInView = false
        //        mobileTextField.leftView = cpv
        //        mobileTextField.leftViewMode = .always
        
        countryPickerView.showCountryCodeInView = false
        countryPickerView.showPhoneCodeInView = true
        
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BenefitTitleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BenefitTitleTableViewCell")
        tableView.register(UINib(nibName: "BenefitsDetailsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BenefitsDetailsTableViewCell")
    }
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Edit button taped
    @objc func onTapEditProfileButton (_ sender:UIButton) {
        print("Edit Button is Taped")
        self.editProfileView.isHidden = false
        scrollView.isHidden = true
    }
    
    //MARK: Camera button taped
    @IBAction func cameraButtonTaped(_ sender: Any) {
        self.showAddProfilePicPopup()
    }
    //MARK: UpdatProfile button taped
    @IBAction func updateProfileButtonTaped(_ sender: Any) {
        self.checkValidation()
    }
    // MARK: - Validate Name Email and  Mobile No
    func checkValidation() {
        if let alert = self.viewModelUpdateProfile?.verifyFields(name:self.nameTextField.text,email: self.emailTextField.text, mobileNo: self.mobileTextField.text), !alert.isEmpty {
            showMessageAlert(message: alert)
        } else {
            self.integrateUpdateProfileApi()
        }
    }
    // Function to update the profile data
    //    func updateProfileData() {
    //        let updatedData = // Updated user data
    //        delegate?.profileDidUpdate(updatedData: updatedData)
    //    }
}

//MARK: Initialize view model
extension ProfileVC{
    // MARK: - Custom functions
    func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ProfileViewModel()
        }
        if self.viewModelUpdateProfile == nil {
            self.viewModelUpdateProfile = UpdateProfileViewModel()
        }
    }
}
//MARK: Profile API Integration
extension ProfileVC{
    private func integrateProfileApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.GET_EMPLOYEE_DETAIL_API
        let employeeId = String(getUserId())
        
        let param:[String:String] = [ "employee_id":employeeId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModel?.requestProfileApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var profileResponse = ProfileResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(ProfileResponse.self, from: jsonData!)
                    print(responseData)
                    profileResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processProfileResponse(receivedData: profileResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process Profile Response
    
    func processProfileResponse(receivedData:ProfileResponse){
        
        print(selectedDate)
        
        if receivedData.status == 1{
            
//            guard let profilePic = receivedData.data?.profilePic else{return}
            let profilePic = receivedData.data?.profilePic ?? ""
            let name = receivedData.data?.name ?? ""
            let email = receivedData.data?.email ?? ""
            let mobile = receivedData.data?.mobile ?? ""
            let shiftName = receivedData.data?.shiftName ?? ""
            let breakDuration = receivedData.data?.breakDuration ?? 0
            let position = receivedData.data?.position ?? ""
            let hourlyRate = receivedData.data?.hourlyRate ?? ""
            let role = receivedData.data?.role ?? ""
            let countryCode = receivedData.data?.cCode  ?? ""
            let maxWorkHoursWeekly = receivedData.data?.maxWorkHourWeekly  ?? ""
            let employeeId = receivedData.data?.employeeID ?? 0
            
//            guard let name = receivedData.data?.name else{return}
//            guard let email = receivedData.data?.email else{return}
//            guard let mobile = receivedData.data?.mobile else{return}
//            guard let shiftName = receivedData.data?.shiftName else{return}
//            guard let breakDuration = receivedData.data?.breakDuration else{return}
//            guard let position = receivedData.data?.position else{return}
//            guard let hourlyRate = receivedData.data?.hourlyRate else{return}
//            guard let role = receivedData.data?.role else{return}
//            guard let countryCode = receivedData.data?.cCode else{return}
//            guard let maxWorkHoursWeekly = receivedData.data?.maxWorkHourWeekly else{return}
//            guard let employeeId = receivedData.data?.employeeID else{return}
            
            selectedCountryCode = countryCode
            countryPickerView.setCountryByPhoneCode(selectedCountryCode)
            
            if let timeZoneLocation = receivedData.data?.timezoneLocation {
                self.timeZoneLabel.text = timeZoneLocation
            }else{
                self.timeZoneLabel.text = ""
            }
            var tagStr = ""
            var finalTagStr = ""
            if let tags = receivedData.data?.tags{
                for item in tags {
                    if let tag = item.tag{
                        tagStr = tag
                        finalTagStr = finalTagStr + tag + " | "
                    }
                }
                if !finalTagStr.isEmpty{
                    finalTagStr.removeLast()
                }
                self.tagsLabel.text = finalTagStr
            }
            finalTagStr = ""
/*            if let benefits = receivedData.data?.benefits{
                for item in benefits {
                    if let tag = item.benefit{
                        tagStr = tag
                        finalTagStr = finalTagStr + tag + " | "
                    }
                }
                if !finalTagStr.isEmpty{
                    finalTagStr.removeLast()
                }
 //               self.benifitsLabel.text = finalTagStr
            } */
            if let benefits = receivedData.data?.benefits{
  //              self.benefits = benefits
                for item in benefits {
                    let benefitData = BenefitsPlan.init(company_pay: item.companyPay, premium_pay: item.premiumPay, employee_pay: item.employeePay)
                    let cellData = CellData.init(title: item.benefit, sectionData: benefitData, isOpened: false)
                    benefitsData.append(cellData)
                }
                
                print(benefitsData)
                

                tableViewHeightConstraint.constant = tableViewHeightConstraint.constant * CGFloat(self.benefitsData.count) + 1
                tableView.reloadData()
                
                // Calculate the content size
//                let contentSize = tableView.contentSize
//                tableViewHeightConstraint.constant = contentSize.height
            }
            
            finalTagStr = ""
            if let weekoff = receivedData.data?.weekOff{
                for item in weekoff {
                    
                    print(item)
                    tagStr = item
                    finalTagStr = finalTagStr + item + ","
                }
                if !finalTagStr.isEmpty{
                    finalTagStr.removeLast()
                }
                
                getWeekDays(receivedData: receivedData)
                //              self.weakLabel.text = finalTagStr
            }
            print(finalTagStr)
            
            let imageUrl = IMAGE_BASE_URL + profilePic
            self.profileImage.sd_setImage(with: URL(string:imageUrl), placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
            self.nameLabel.text = name
            self.emailLabel.text = email
            self.phoneLabel.text = mobile
            self.breakLabel.text = "\(breakDuration)"
            self.positionLabel.text = position
            self.hourlyLabel.text = hourlyRate
            self.reportingLabel.text = ""
            self.shiftLabel.text = shiftName
            self.rollLabel.text = role
            self.maxHoursLabel.text = maxWorkHoursWeekly
            self.employeeId.text = "\(employeeId)"
            
            self.profilePic.sd_setImage(with: URL(string:imageUrl), placeholderImage:  #imageLiteral(resourceName: "profilePlaceHolder"))
            self.nameTextField.text = name
            self.emailTextField.text = email
            self.mobileTextField.text = mobile
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
    
    func getWeekDays(receivedData:ProfileResponse){
        struct WeekOffData{
            var day = String()
            var id = String()
        }
        var weekOffDict: [WeekOffData] = [
            WeekOffData(day: "Monday", id: "0"),
            WeekOffData(day: "Tuesday", id: "1"),
            WeekOffData(day: "Wednesday", id: "2"),
            WeekOffData(day: "Thursday", id: "3"),
            WeekOffData(day: "Friday", id: "4"),
            WeekOffData(day: "Saturday", id: "5"),
            WeekOffData(day: "Sanday", id: "6")]
        
        var weekDays = [WeekOffData]()
        
            if receivedData.data?.weekOff?.count != 0{
                for item in receivedData.data?.weekOff ?? []{
                    if let dayId = weekOffDict.first(where: {$0.id == item}){
                        weekDays.append(dayId)
                    }
                }
                let dayArr = weekDays.map({$0.day})
                print(dayArr)
                self.weakLabel.text = dayArr.joined(separator: ",")
                
            }else{
                weakLabel.text = ""
            }
    }
    
}

//MARK: Update Profile API Integration
extension ProfileVC{
    private func integrateUpdateProfileApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.UPDATE_PROFILE_API
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        let userId = String(getUserId())
        var param:[String:Any]
        
        //        param = [ "employee_id":employeeId,"company_id":companyId,"name":self.nameTextField.text!,"mobile":self.mobileTextField.text!,"user_id":userId,"email":self.emailTextField.text!,"c_code":"+91"]
        
        param = pickedImageUrl == nil ? [ "employee_id":employeeId,"company_id":companyId,"name":self.nameTextField.text!,"mobile":self.mobileTextField.text!,"user_id":userId,"c_code":selectedCountryCode] : [ "employee_id":employeeId,"company_id":companyId,"name":self.nameTextField.text!,"mobile":self.mobileTextField.text!,"user_id":userId,"c_code":selectedCountryCode,"profile_pic":pickedImageUrl ?? ""]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModelUpdateProfile?.requestUpdateProfileApi(apiName: fullUrl, param: param, pickedImageUrl: pickedImageUrl, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var profileResponse = ProfileResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(ProfileResponse.self, from: jsonData!)
                    //                    print(responseData)
                    profileResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processUpdateProfileResponse(receivedData: profileResponse)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    //MARK: Process Update Profile Response
    
    func processUpdateProfileResponse(receivedData:ProfileResponse){
        
        if receivedData.status == 1{
            
            guard let profilePic = receivedData.data?.profilePic else{return}
            guard let name = receivedData.data?.name else{return}
            guard let email = receivedData.data?.email else{return}
        
            let message = receivedData.message ?? ""
            showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
                
                // ********** Pass data to Side Menue By Notification Center *************
                let employeeCompanyName = getCompanyName()
                let dataDict = ["employeeName":name,"employeeEmail":email,"employeeCompanyName":employeeCompanyName,"employeeProfilePic":profilePic]
                
                //                          NotificationCenter.default.post(name: NSNotification.Name(rawValue:NOTIFICATION_KEYS.EMPLOYEE_DATA), object: nil, userInfo: dataDict)
                
                self.delegate?.profileDidUpdate(updatedData: dataDict)
                
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
extension ProfileVC:UITextFieldDelegate{
    func textView(_ textField: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textField == self.emailTextField ? false:true
    }
}
extension ProfileVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
       return self.benefitsData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  benefitsData[section].isOpened == true{
            return 1 + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitTitleTableViewCell", for: indexPath) as? BenefitTitleTableViewCell else{return UITableViewCell()}
            
            let info = benefitsData[indexPath.section]
            cell.configureCell(info: info, index: indexPath.section)
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitsDetailsTableViewCell", for: indexPath) as? BenefitsDetailsTableViewCell else{return UITableViewCell()}
            
            let info = benefitsData[indexPath.section].sectionData
            cell.configureCell(info: info, index: indexPath.section)
            return cell
        }
    }

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row == 0{
                if benefitsData[indexPath.section].isOpened == true{
                    benefitsData[indexPath.section].isOpened = false
                    tableViewHeightConstraint.constant = tableViewHeightConstraint.constant - 101

                    let sections = IndexSet.init(integer: indexPath.section)
            
                    tableView.reloadSections(sections, with: .none)
            }else{
                benefitsData[indexPath.section].isOpened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableViewHeightConstraint.constant = tableViewHeightConstraint.constant + 101
                tableView.reloadSections(sections, with: .none)
            }
                tableView.reloadData()
//                print(tableView.contentSize.height)
//
                
        }
  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}
