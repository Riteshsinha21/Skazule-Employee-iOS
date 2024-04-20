//
//  WorkChatGroupDetailsVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 8/24/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

var updateGroupRoomId   = ""
var updateGroupTitle    = ""
var alreadyAddedUserArr = [String]()

class WorkChatGroupDetailsVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var addParticipantBtn: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    //MARK: Variables
    
    
    var myChatDetail    = FBDChatRoom()
    var userInfo        = [String:Any]()
    var usersDetailArr  = [FirebaseUser1]()
    private let fdbRef  = Database.database().reference()
    var fdbSenderId     = ""
    //For work chat with firebase
    private let loginUserViewModel = FireBaseManager()
    //Custom View
//    var addParticipantPopUP : WCAddParticipantPopUP!
    
    // Create a DispatchGroup
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        configureNavigationBar()
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fdbSenderId =  getFirebaseUserId() //UserDefaults.standard.value(forKey: "userId") as? String ?? ""
        updateGroupRoomId = myChatDetail.roomId ?? ""
    }
    //MARK: Private functions
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WorkChatEmployeeListCell", bundle: Bundle.main), forCellReuseIdentifier: "WorkChatEmployeeListCell")
    }
    private func configureNavigationBar(){
        
        customNavigationBar.customRightBarButton.isHidden = true
        self.customNavigationBar.titleLabel.text = "Group Info"
    }
    private func setUpData(){
        let groupName = myChatDetail.meta?["title"] as? String
        let groupImageUrlStr = myChatDetail.meta?["icon"] as? String
        let groupImageUrl = URL(string: groupImageUrlStr ?? "")
        self.groupNameLabel.text = groupName
        self.groupImage.sd_setImage(with: groupImageUrl, placeholderImage: #imageLiteral(resourceName: "profilePlaceHolder"))
        
        self.userInfo.removeAll()
        if myChatDetail.users?.count ?? 0 > 0{
            self.userInfo = myChatDetail.users!
            
            alreadyAddedUserArr.removeAll()
            for (key,_) in self.userInfo{
                alreadyAddedUserArr.append(key)
            }
        }
        print(alreadyAddedUserArr)
        print(self.userInfo)
        
        self.getUserInfo()
        
        
        // Define a notification name as a string constant
        let myNotificationName = Notification.Name("MyCustomNotification")
        // Add the observer in your view controller or any other class
        NotificationCenter.default.addObserver(self, selector: #selector(handleCustomNotification), name: myNotificationName, object: nil)
        
    }
    
    //MARK: Get User Information From Firebase
    
    private func getUserInfo(){
        
        if userIdArray.count > self.userInfo.count{
            for (index, value) in userIdArray.enumerated() {
                if let matchingKey = self.userInfo.keys.first(where: { $0 == value }) {
                    let matchingIndex = index
                  //  print("Value \(value) at index \(matchingIndex) matches key \(matchingKey) in the dictionary.")
                }else{
                    let arrayValue = userIdArray[index]
                    self.userInfo[arrayValue] = true
                }
            }
        }
        if (userIdArray.count < self.userInfo.count) && (userIdArray.count != 0){
            
            self.userInfo.removeAll()
            for item in userIdArray {
                self.userInfo[item] = true
            }
        }
        
        self.usersDetailArr.removeAll()
//        if self.userInfo.count == userIdArray.count
//        {
            for (key,_) in self.userInfo
            {
                print(key)
                dispatchGroup.enter()
                
                getUserInfoFromFirebase(userId: key) { result in
                    self.dispatchGroup.leave()
                    print(self.usersDetailArr.count)
                    
                    
//                    if (userIdArray.count == self.userInfo.count) && (self.userInfo.count == self.usersDetailArr.count )
//                    {
//                        self.tblView.reloadData()
//                    }
//
//                    if (self.userInfo.count > userIdArray.count)
//                    {
//                        self.tblView.reloadData()
//                    }
                    
                }
            }
//        }
        // Notify when all tasks are done
        dispatchGroup.notify(queue: .main) {
            // This code will be executed when all tasks are completed
            print("All Firebase calls completed.")
            
            // We use code line 207 to 215(before tblView reloadData ) for remove duplicates from usersDetailArr
            var uniqueUsers = [FirebaseUser1]()
            for user in self.usersDetailArr {
                if !uniqueUsers.contains(where: { $0.email == user.email }) {
                    uniqueUsers.append(user)
                }
            }
            self.usersDetailArr.removeAll()
            self.usersDetailArr = uniqueUsers
            self.tableView.reloadData()
        }
    }
    func getUserInfoFromFirebase(userId: String, onSuccess:@escaping(String) -> Void){
        fdbRef.child("Users").queryOrdered(byChild: "userId").queryEqual(toValue: userId).observeSingleEvent(of: .value) { snapshot in
            
            guard snapshot.exists() else { return }
            
            if let dataDict = snapshot.value as? [String:AnyObject]{
                let email     = dataDict[userId]!["email"] as? String
                let profile   = dataDict[userId]!["profile"] as? String
                let userId    = dataDict[userId]!["userId"] as? String
                let userName  = dataDict[userId!]!["userName"] as? String
                let timestamp = dataDict[userId!]!["timestamp"] as? String
                
                let user = FirebaseUser1(email: email, profile: profile, userId: userId, userName: userName, timestamp: timestamp)
//                print(user)
                print(self.usersDetailArr.count)
                print(self.userInfo.count)
                print(userIdArray.count)
                self.usersDetailArr.append(user)
                onSuccess("true")
//
//                if (userIdArray.count == self.userInfo.count) && (self.userInfo.count < self.usersDetailArr.count)
//                {
//                }
//                else
//                {
//                    self.usersDetailArr.append(user)
//                    onSuccess("true")
//                }
            }
        }
    }
    // Define a function to handle the notification
    @objc func handleCustomNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            //            self.userInfo.removeAll()
            //            if myChatDetail.users?.count ?? 0 > 0
            //            {
            //                self.userInfo = myChatDetail.users!
            //                alreadyAddedUserArr.removeAll()
            //                for (key,_) in self.userInfo
            //                {
            //                    alreadyAddedUserArr.append(key)
            //                }
            //            }
            
            
            self.getUserInfo()
            
            //            if let value = userInfo["key"] as? String {
            //                print("Received notification with value: \(value)")
            //            }
        }
    }
    
}
//MARK: Table View Delegate and Data Source
extension WorkChatGroupDetailsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersDetailArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkChatEmployeeListCell", for: indexPath) as? WorkChatEmployeeListCell else{return UITableViewCell()}
//        cell.delegate = self
        cell.selectionStyle = .none
        let info = self.usersDetailArr[indexPath.row]
//        cell.isFrom = self.isCommingFrom
        cell.empFirebaseData = info
//        print(self.isCommingFrom)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 85 //UITableView.automaticDimension
    }
}
