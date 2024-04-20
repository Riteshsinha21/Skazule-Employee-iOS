//
//  WorkChatVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/31/23.
//

import UIKit
import SwiftyJSON
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


var myChatUserList   = [FBDChatRoom]()
var myChatGroupUserList  = [FBDChatRoom]()


var myChatUserListArrDict   = [String: Any]()
var userIdArray = [String]()
var userList = [String:Any]()
var chatType = "individual"
var roomDataDictArr = [String: AnyObject]()


class WorkChatVC: UIViewController {
    
    
    //MARK: IBOutlets
    
    @IBOutlet weak var customNavigationBarForDrawer: CustomNavigationBarForDrawer!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //MARK: VAriables
    //1 For search
    var filterUserList   = [FBDChatRoom]()
    var filterGroupUserList   = [FBDChatRoom]()
    var filteredData = [FBDChatRoom]()
    var currentSearchText: String?
    var isSearching = false
    
    private let fdbRef = Database.database().reference()
    
    
    var group = DispatchGroup()
    
    var segmentIndex    = 0
    var actionSheetOption1Title = KNewChat
    var users = [FirebaseUser]()
    let chatViewModel = ChatViewModel()
    var email = ""
    
    // MARK: - Pull-to-Refresh   // PtR 1
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(self.handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = .black
        return refreshControl
    }()
    // PtR 2
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //currentPageIndex = 1
        let senderID = getFirebaseUserId()  //UserDefaults.standard.string(forKey: "userId") ?? ""
        self.getRoomId(senderID: senderID) { user in
            print("call and get api response")
        }
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        searchTextField.delegate = self
        configureNavigationBar()
        configureTableView()
//        configureRefreshCntrol()
       
        self.noDataView.isHidden = false
        self.tableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let senderID = getFirebaseUserId()
        self.getRoomId(senderID: senderID) { user in
            print("call and get api response")
                        
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
                    self.filterUserList = myChatUserList
                    self.filterGroupUserList = myChatGroupUserList
                    print(self.filterUserList.count,myChatUserList.count)
                    print(self.filterGroupUserList.count,myChatGroupUserList.count)
                    self.setUpNodataFoundView(userList: myChatUserList)
                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
            }
        }
    }
    //MARK: Private functions
    private func setUp(){
        self.recheckVM()
    }
    private func configureNavigationBar(){
        self.customNavigationBarForDrawer.titleLabel.text = "Work Chat"
        let roleId = getRoleId() // Get RoleId from User Defaults
//        customNavigationBarForDrawer.rightBtn.isHidden = (roleId == Int(KFive) || roleId == Int(KSix)) ? false : true
//        if (roleId == Int(KFive) || roleId == Int(KSix)){
//            customNavigationBarForDrawer.rightBtn.setImage(UIImage(named: "dots"), for: .normal)
//            customNavigationBarForDrawer.rightBtn.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
//            customNavigationBarForDrawer.notificationView.isHidden = true
//        }else{
//            customNavigationBarForDrawer.notificationView.isHidden = false
//            customNavigationBarForDrawer.rightBtn.isHidden = true
//            customNavigationBarForDrawer.rightBtn.setImage(UIImage(named: "notification"), for: .normal)
//            customNavigationBarForDrawer.rightBtn.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
//            customNavigationBarForDrawer.notificationView.isHidden = true
//        }
        customNavigationBarForDrawer.rightBtn.isHidden = true
        customNavigationBarForDrawer.notificationView.isHidden = true
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WorkChatTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WorkChatTableViewCell")
    }
    private func configureRefreshCntrol(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) //
    }
    //MARK: Notification button taped
    @objc func didTapNotificationButton (_ sender:UIButton) {
        print("Notification Button is Taped")
        let vc = NotificationsVC()
        vc.notificationsListRespose = customNavigationBarForDrawer.notificationsListRespose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        //getUsersList()
        //self.getUserListByRoomId()
    }
    //MARK: Search button taped
    @IBAction func searchButtonTaped(_ sender: Any) {
        if searchTextField.text != ""{
            //        self.integrateWorkChatApi()
        }
    }
    //MARK: More button taped
    @objc func didTapMoreButton (_ sender:UIButton) {
        print("More Button is selected")
        openActionSheet()
    }
    //MARK: Search text changed
    @IBAction func searchTextChanged(_ sender: UITextField) {
//        self.currentSearchText = sender.text
//
//        if segmentControl.selectedSegmentIndex == 0{
//            filterData(with: sender.text,originalData: myChatUserList)
//        }else{
//            filterData(with: sender.text,originalData: myChatGroupUserList)
//        }
//        tableView.reloadData()
    }
    
    //MARK: Filter the data based on the search text
//    func filterData(with searchText: String?,originalData:[FBDChatRoom]) {
//
//        if searchText != ""{
//            isSearching = true
//            filteredData.removeAll()
//
//        }
//
//            tableView.reloadData()
//    }
    // Helper function to filter data based on search text
    func filterData(searchText: String) {
        
        print(self.segmentIndex)
        if (self.segmentIndex == 0){
            if searchText.isEmpty {
                self.filterUserList = myChatUserList
            } else {
                print(self.filterUserList.count)
                self.filterUserList = myChatUserList.filter { $0.meta2?.userName!.lowercased().contains(searchText.lowercased()) ?? false }
                print(self.filterUserList.count)
            }
        }
        else{
            if searchText.isEmpty{
                self.filterGroupUserList = myChatGroupUserList
            }
            else{
                print(self.filterGroupUserList.count)
                self.filterGroupUserList = searchGroupUser(searchText: searchText)
                print(self.filterGroupUserList.count)
            }
        }
        tableView.reloadData()
    }
    func searchGroupUser(searchText:String) -> [FBDChatRoom] {
        return myChatGroupUserList.filter { model in
            guard let value = model.meta!["title"] as? String else {
                return false
            }
            return value.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    
    
    //MARK: Segment Button Taped
    @IBAction func segmentTaped(_ sender: Any) {
        
        print(segmentControl.selectedSegmentIndex)
        if segmentControl.selectedSegmentIndex == 0{
            self.segmentIndex = 0
            self.actionSheetOption1Title = KNewChat
            setUpNodataFoundView(userList: myChatUserList)
        }else{
            print(segmentControl.selectedSegmentIndex)
            self.segmentIndex = 1
            self.actionSheetOption1Title = KNewGroup
            setUpNodataFoundView(userList: myChatGroupUserList)
        }
    }
    //MARK: Set up No data found view
    func setUpNodataFoundView(userList:[FBDChatRoom]){
    
        DispatchQueue.main.async {
        if userList.count != 0{
                self.noDataView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }else{
                self.noDataView.isHidden = false
                self.tableView.isHidden = true
            }
    }
  }
    //MARK: Get Room ID
    func getRoomId(senderID: String, onSuccess:@escaping([FBDChatRoom]) -> Void){

        myChatUserList.removeAll()
        myChatGroupUserList.removeAll()
        
        fdbRef.child("chatRoom").queryOrdered(byChild: "users/"+senderID).queryEqual(toValue: true).observeSingleEvent(of: .value) { snapshot in
            
//            if snapshot.exists()
//            {}
//            else
//            {
//                if myChatUserList.count == 0
//                {
//                    self.tableView.isHidden   = true
//                    self.tableView.isHidden = false
//                }
//                else
//                {
//                    self.tableView.isHidden   = false
//                    self.tableView.isHidden = true
//                }
//            }
            
            
            guard snapshot.exists() else { return }
            if let dataDict = snapshot.value as? [String:AnyObject]{
                var result: [String:AnyObject] = [:]
                for (key, _) in dataDict {
                    //   for key in dataDict{
                    //    if key["type"] != Kgroup{
                    
                    if dataDict[key]?["type"] as! String != Kgroup { // For single chat
                        result = dataDict[key]?["users"] as! [String : AnyObject]
                        for (userKey,_) in result
                        {
                            if(userKey != senderID){
                                let user1 = dataDict[key] as! [String : Any]
                                var firebaseUserData = [Meta2]()
                                
                                self.fdbRef.child("Users/"+userKey).observeSingleEvent(of: .value, with: { snapshot in
                                    guard snapshot.exists() else { return }
                                    
                                    if let dataDict = snapshot.value as? [String:AnyObject]{
                                        
                                        let email         = dataDict["email"] as? String
                                        let profile       = dataDict["profile"] as? String
                                        let userId        = dataDict["userId"] as? String
                                        let userName      = dataDict["userName"] as? String
                                        let timestamp     = dataDict["timestamp"] as? String
                                        
                                        let user = Meta2(userId: userId, userName: userName, userEmail: email, userMobile: "", timestamp: timestamp, profileImage: profile)
                                        firebaseUserData.append(user)
                                        
                                        let lastMessageText   = user1["lastMessageText"] ?? ""
                                        let lastMessage       = user1["lastMessage"] ?? ""
                                        let type              = user1["type"] ?? ""
                                        let creator           = user1["creator"] ?? ""
                                        let meta              = user1["meta"] as! [String : Any]
                                        let users             = user1["users"] as! [String : Any]
                                        let user_key          = userKey
                                        let roomId            = key
                                        
                                        myChatUserList.append(FBDChatRoom.init(lastMessageText: lastMessageText as? String, lastMessage: lastMessage as? String, type: type as? String, creator: creator as? String, meta: meta, users: users,roomId: roomId, user_key: user_key, meta2: user))
                                        print("****************************\(myChatUserList)")
                                        
//                                        if myChatUserList.count != 0{
//                                            self.noDataView.isHidden = true
//
                                        DispatchQueue.main.async {
//                                            self.tableView.refreshControl?.endRefreshing()
//                                            self.tableView.reloadData()
                                            //self.hideLoading()
//                                            myChatUserList = myChatUserList.sorted{$0.lastMessage! < $1.lastMessage!}
                                            onSuccess(myChatUserList)
                                         }
//                                        }else{
//                                            self.noDataView.isHidden = false
//                                        }
                        
                                    }
                                })
                            }
                        }
                    }else{ // for group chat
                        let groupUserData     = dataDict[key] as! [String : Any]
                        let lastMessageText   = groupUserData["lastMessageText"] ?? ""
                        let lastMessage       = groupUserData["lastMessage"] ?? ""
                        let type              = groupUserData["type"] ?? ""
                        let creator           = groupUserData["creator"] ?? ""
                        let meta              = groupUserData["meta"] as! [String : Any]
                        let users             = groupUserData["users"] as! [String : Any]
                        let roomId            = key
                        
                        //                            myChatUserList.append(FBDChatRoom.init(lastMessageText: lastMessageText as? String, lastMessage: lastMessage as? String, type: type as? String, creator: creator as? String, meta: meta, users: users,roomId: roomId))
                        
                        myChatGroupUserList.append(FBDChatRoom.init(lastMessageText: lastMessageText as? String, lastMessage: lastMessage as? String, type: type as? String, creator: creator as? String, meta: meta, users: users,roomId: roomId))
                        
                        
                        /*
                         var myChatUserList = [ChatRoomUsers]()
                         let roomId = key
                         let roomData = dataDict
                         let chatRoomUsers = ChatRoomUsers.init(roomId: roomId, roomData: roomData)
                         myChatUserList.append(chatRoomUsers)
                         */
                        
                        
                        DispatchQueue.main.async {
//                            self.tableView.refreshControl?.endRefreshing()
//                            self.tableView.reloadData()
                            //self.hideLoading()
                            myChatGroupUserList = myChatGroupUserList.sorted{$0.lastMessage! < $1.lastMessage!}
                            onSuccess(myChatGroupUserList)
                        }
                    }
                }
               
                
                onSuccess(myChatUserList)
            }
        }
    }
    
    
    
    //
    //        myChatUserList.removeAll()
    //        var chatRoomData = [FBDChatRoom]()
    //
    //        fdbRef.child("chatRoom").queryOrdered(byChild: "users/"+senderID).queryEqual(toValue: true).observeSingleEvent(of: .value) { snapshot in
    //            guard snapshot.exists() else{
    //                self.noDataView.isHidden = false
    //                return }
    //            if let dataDict = snapshot.value as? [String:AnyObject]{
    //                var result: [String:AnyObject] = [:]
    //
    //                let roomIdStr = dataDict.keys
    //
    //                //                  let group = DispatchGroup()
    //                //                  var runningTotal = 0
    //
    //                for (key, _) in dataDict {
    //
    //                    //                      group.enter()
    //
    //                    if dataDict[key]?["type"] as! String != "group"
    //                    {
    //
    //                        print(roomIdStr)
    //                        result = dataDict[key]?["users"] as! [String : AnyObject]
    //                        for (userKey,_) in result
    //                        {
    //                            //                              group.enter()
    //                            if(userKey != senderID){
    //                                var user1 = dataDict[key] as! [String : Any]
    //                                //self.getMyFriendUser_async(user_id: userKey, roomId: key, roomData: user1)
    //
    //                                var firebaseUserData = [Meta2]()
    //                                self.fdbRef.child("Users/"+userKey).observeSingleEvent(of: .value, with: { snapshot in
    //
    //                                    guard snapshot.exists() else { return }
    //
    //                                    if let dataDict = snapshot.value as? [String:AnyObject]{
    //
    //                                        //                                          defer { group.leave() }
    //
    //
    //                                        let email         = dataDict["email"] as? String
    //                                        let profile       = dataDict["profile"] as? String
    //                                        let userId        = dataDict["userId"] as? String
    //                                        let userName      = dataDict["userName"] as? String
    //                                        let timestamp     = dataDict["timestamp"] as? String
    //
    //                                        let user = Meta2(userId: userId, userName: userName, userEmail: email, userMobile: "", timestamp: timestamp, profileImage: profile)
    //                                        firebaseUserData.append(user)
    //
    //                                        let lastMessageText   = user1["lastMessageText"] ?? ""
    //                                        let lastMessage       = user1["lastMessage"] ?? ""
    //                                        let type              = user1["type"] ?? ""
    //                                        let creator           = user1["creator"] ?? ""
    //                                        let meta              = user1["meta"] as! [String : Any]
    //                                        let users             = user1["users"] as! [String : Any]
    //                                        let user_key          = userKey
    //                                        let roomId            = key
    //
    //
    //                                        myChatUserList.append(FBDChatRoom.init(lastMessageText: lastMessageText as? String, lastMessage: lastMessage as? String, type: type as? String, creator: creator as? String, meta: meta, users: users,roomId: roomId, user_key: user_key, meta2: user))
    //                                        print("****************************\(myChatUserList)")
    //
    //                                        if myChatUserList.count != 0{
    //                                            self.noDataView.isHidden = true
    //                                            DispatchQueue.main.async {
    //                                                self.tableView.reloadData()
    //                                            }
    //                                        }else{
    //                                            self.noDataView.isHidden = false
    //                                        }
    //
    //
    //                                        //print("################################################################3##\(myChatUserList.count)")
    //                                        //runningTotal += amount
    //                                        //                                          runningTotal = myChatUserList.count
    //                                        //                                          group.leave()
    //                                        //group.leave()
    //                                    }
    //                                })
    //                            }
    //                        }
    //                        //                          group.leave()
    //                    }
    //                }
    //                //                  group.notify(queue: .main) {
    //                //                      onSuccess(myChatUserList)
    //                //                       }
    //                onSuccess(myChatUserList)
    //            }
    //        }
    //    }
    //MARK: Open Action Sheet on tap of three dots
    func openActionSheet(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let option1 = UIAlertAction(title: KNewChat, style: .default) { _ in
            // Handle the selection of option 1
            
                let vc = WorkChatEmployeeListVC()
                vc.isCommingFrom = self.actionSheetOption1Title
                self.navigationController?.pushViewController(vc, animated: true)
        }
        let option1Icon = UIImage(named: "newChat.png")
        //        option1.setValue(option1Icon?.imageWithSize(scaledToSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), forKey: "image")
        option1.setValue(option1Icon?.imageWithSize(scaledToSize: CGSize(width: 25, height: 25)), forKey: "image")
        
        let option2 = UIAlertAction(title: KNewGroup, style: .default) { _ in
            // Handle the selection of option 2
            let vc = WCCreateGroupVC()
            vc.isCommingFrom = KNewGroup//self.actionSheetOption1Title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let option2Icon = UIImage(named: "add-group.png")
        //        option2.setValue(option2Icon?.imageWithSize(scaledToSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), forKey: "image")
        option2.setValue(option2Icon?.imageWithSize(scaledToSize: CGSize(width: 25, height: 25)), forKey: "image")
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle the cancellation of the action sheet
        }
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    func dnkffks()
    {
        print("Get users list")
        chatViewModel.getUsersList { (usersList) in
            self.users = usersList
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                //                self.messagesTableView.reloadData()
                //                self.hideLoading()
            }
            
        } onError: { (errorMessage) in
            print(errorMessage)
        }
    }
    func getUsersList(){
        //print("Get users list")
        chatViewModel.getUsersList { (usersList) in
            self.users = usersList
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                //                self.messagesTableView.reloadData()
                //                self.hideLoading()
            }
            
        } onError: { (errorMessage) in
            print(errorMessage)
        }
    }
    
    //        func getUserListByRoomId(){
    //            guard let employerId = UserDefaults.standard.string(forKey: "userId") else { return }
    //            chatViewModel.getRoomId(senderID: employerId)
    //            self.group.notify(queue: .main) {
    //
    //                print("&&&&&&%%%%%%$$$$$$#####\(myChatUserList.count)")
    //            }
    //
    //        }
    
    //   func getUserListByRoomId() async throws -> [FBDChatRoom]{
    
    //        let result = [FBDChatRoom]()
    //
    //        var UserID = [String]()
    //        var RoomID = [String]()
    //        var RoomData = [NSMutableDictionary]()
    //
    //
    //        let senderID = UserDefaults.standard.string(forKey: "userId")
    //        myChatUserList.removeAll()
    //
    //        //        group.enter()
    //        fdbRef.child("chatRoom").queryOrdered(byChild: "users/"+(senderID ?? "")).queryEqual(toValue: true).observeSingleEvent(of: .value) { snapshot in
    //            // print(snapshot)
    //            // NotificationCenter.default.post(name: NSNotification.Name("Message"), object: nil)
    //            guard snapshot.exists() else { return }
    //            if let dataDict = snapshot.value as? [String:AnyObject]{
    //                var result: [String:AnyObject] = [:]
    //
    //
    //
    //                for (key, _) in dataDict {
    //                    if dataDict[key]?["type"] as! String != "group"
    //                    {
    //                        result = dataDict[key]?["users"] as! [String : AnyObject]
    //
    //                        RoomID.append(key)
    //
    //
    //                        for (userKey,_) in result
    //                        {
    //                            if(userKey != senderID){
    //
    //                                var user = dataDict[key] as! NSMutableDictionary//[String : Any]
    //                                UserID.append(userKey)
    //                                RoomData.append(user)
    //
    //                            }
    //                        }
    ////                        Task{
    ////                            try? await (self.getMyFriendUser_async(user_id: UserID, roomId: RoomID, roomData: RoomData))
    ////                        }
    //                        let data = try await self.getMyFriendUser_async(user_id: UserID, roomId: RoomID, roomData: RoomData)
    //
    //
    //                    }
    //                    else{
    //                        //want this check and modify this accordin to our condition
    //                        var list = [Any]()
    //                        list.append(key)
    //                        var myChatUserList = [ChatRoomUsers]()
    //                        let roomId = key
    //                        let roomData = dataDict
    //                        let chatRoomUsers = ChatRoomUsers.init(roomId: roomId, roomData: roomData)
    //                        myChatUserList.append(chatRoomUsers)
    //                    }
    //                }
    //
    //
    //            }
    //
    //        }
    //
    //        return result
    //        group.leave()
    //print("##################################################################\(myChatUserList.count)")
    //    }
    
    private func getMyFriendUser_async(
        user_id: [String] ,
        roomId: [String],
        roomData: [NSMutableDictionary]
    ) {
        var firebaseUserData = [Meta2]()
        for  item in user_id {
            
            self.fdbRef.child("Users/"+item).observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { return }
                
                
                if let dataDict = snapshot.value as? [String:AnyObject]{
                    
                    let email         = dataDict["email"] as? String
                    let profile       = dataDict["profile"] as? String
                    let userId        = dataDict["userId"] as? String
                    let userName      = dataDict["userName"] as? String
                    let timestamp     = dataDict["timestamp"] as? String
                    
                    let user = Meta2(userId: userId, userName: userName, userEmail: email, userMobile: "", timestamp: timestamp, profileImage: profile)
                    firebaseUserData.append(user)
                    
                    
                    
                    let lastMessageText   = roomData[0]["lastMessageText"]
                    let lastMessage       = roomData[0]["lastMessage"]
                    let type              = roomData[0]["type"]
                    let creator           = roomData[0]["creator"]
                    let meta              = roomData[0]["meta"] as! [String : Any]
                    let users             = roomData[0]["users"] as! [String : Any]
                    let user_key          = item
                    
                    //                    FBDChatRoom.init(lastMessageText: lastMessageText as? String, lastMessage: lastMessage as? String, type: type as? String, creator: creator as? String, meta: meta, users: users, user_key: user_key, meta2: user)
                    //chatRoomObj = FBDChatRoom.init(lastMessageText: lastMessageText as? String, lastMessage: lastMessage as? String, type: type as? String, creator: creator as? String, meta: meta, users: users, user_key: user_key, meta2: user)
                    
                    myChatUserList.append(FBDChatRoom.init(lastMessageText: lastMessageText as? String, lastMessage: lastMessage as? String, type: type as? String, creator: creator as? String, meta: meta, users: users, user_key: user_key, meta2: user))
                    
                    print("valueee------->\(myChatUserList)")
                    
                    //print("*************************************************************************\(myChatUserList)")
                    //print("################################################################3##\(myChatUserList.count)")
                    
                }
                //            miniGroup.leave()
                //                print("Count   ################################################################3##\(myChatUserList.count)")
            })
        }
        print("Count-------->>>>###############################################################3##\( myChatUserList.count)")
        
    }
}

//MARK: Initialize view model
extension WorkChatVC{
    // MARK: - Custom functions
    func recheckVM() {
        //   if self.viewModel == nil {
        //        self.viewModel = DocumentsViewModel()
        //    }
    }
}
//MARK: Table View Delegate and Data Source
extension WorkChatVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(filterGroupUserList.count)
        return  self.segmentControl.selectedSegmentIndex == 0 ? filterUserList.count : filterGroupUserList.count //groups.count
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkChatTableViewCell", for: indexPath) as? WorkChatTableViewCell else{return UITableViewCell()}
        
        cell.selectionStyle = .none
        
//        let info = self.segmentControl.selectedSegmentIndex == 0 ? myChatUserList[indexPath.row] : myChatGroupUserList[indexPath.row]
        let info = self.segmentControl.selectedSegmentIndex == 0 ? filterUserList[indexPath.row] : filterGroupUserList[indexPath.row]
        print(info)
        cell.myChatData = info
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = WorkChatDetailsChatVC()
        
        if self.segmentControl.selectedSegmentIndex == 0 {     // For one to one chat
            
        let info = filterUserList[indexPath.row]
        vc.name = info.meta2?.userName ?? ""
        vc.roomId = info.roomId ?? ""
        vc.receiverId = info.meta2?.userId ?? "" // this id want to check with android developer
        vc.profilePhoto = info.meta2?.profileImage ?? ""
        vc.myChatUserDetail = info
        self.navigationController?.pushViewController(vc, animated: true)
        }else{          // For Group Chat
            let info = filterGroupUserList     [indexPath.row]
            
            print(info)

            vc.name = info.meta?["title"] as? String ?? ""
            vc.roomId = info.roomId ?? ""
            vc.receiverId = info.meta2?.userId ?? "" // this id want to check with android developer
            vc.profilePhoto = info.meta?["icon"] as? String ?? ""
            vc.myChatUserDetail = info
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90 //UITableView.automaticDimension
    }
}

//MARK: Text Field Delegates
extension WorkChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.currentSearchText = textField.text
        return true
    }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            self.filterData(searchText: searchText)
            return true
        }
    
}
