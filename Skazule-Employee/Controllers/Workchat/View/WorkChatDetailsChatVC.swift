//
//  WorkChatDetailsChatVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 7/25/23.
//

import UIKit
import FirebaseAuth
import MobileCoreServices
import SwiftyJSON
import FirebaseDatabase
import FirebaseStorage

struct NotificationKeys {
    static let MESSAGE = "Message"
}

var broadcastSelectionStatus  = false
var discussionSelectionStatus = true
var ImageUrlStr = ""



class WorkChatDetailsChatVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var sendMsgTxtView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var receiverProfileImgView: UIImageView!
    @IBOutlet weak var receiverName: UILabel!
    
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: Variables
    var roomId = ""
    var user: FirebaseUser?
    var profilePhoto = String()
    let imagePicker = UIImagePickerController()
    var name = ""
    var profilePicUrl = ""
    var firstmessages = ""
    
    var fcmKeys = [JSON]()
    private let chatViewModel = ChatViewModel()
    var myChatUserDetail    = FBDChatRoom()
    var messages = [Message2]()
    
    var senderId   = ""
    var receiverId = ""
    var userInfo   = [String:Any]()
    var usersInfoDetailArr  = [FirebaseUser1]()
    var isCommingFrom       = ""
    var isBroadcast         = false
    var reciverFCMKey = ""
    private let fdbRef      = Database.database().reference()
    
    //Custom Pop Up View
    var imagePopUp : WCViewImagePopUp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpData()
        configureNavigationBar()
        configureTableView()
        self.getMessages()
        self.userInfoDetail()
//        addNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpData()
        addNotificationObserver()
    }
    //MARK: Private functions
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.isHidden = true
        customNavigationBar.customRightBarButton.isHidden = true
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SenderCell", bundle: .main), forCellReuseIdentifier: "SenderCell")
        self.tableView.register(UINib(nibName: "SenderImageCell", bundle: .main), forCellReuseIdentifier: "SenderImageCell")
        self.tableView.register(UINib(nibName: "ReceiverCell", bundle: .main), forCellReuseIdentifier: "ReceiverCell")
        self.tableView.register(UINib(nibName: "ReceiverImageCell", bundle: .main), forCellReuseIdentifier: "ReceiverImageCell")
    }
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func userInfoDetail(){
        self.userInfo.removeAll()
        
        if self.myChatUserDetail.users?.count ?? 0 > 0{
            self.userInfo = self.myChatUserDetail.users!
        }
        self.getUserInfo()
    }
    
    private func getUserInfo(){
        
         let senderID = getFirebaseUserId()//UserDefaults.standard.string(forKey: "userId")
        
        self.usersInfoDetailArr.removeAll()
        for (key,_) in self.userInfo
        {
            print(key)
            fdbRef.child("Users").queryOrdered(byChild: "userId").queryEqual(toValue: key).observeSingleEvent(of: .value) { snapshot in
                
                guard snapshot.exists() else { return }
                
                if let dataDict = snapshot.value as? [String:AnyObject]{
                    let email     = dataDict[key]!["email"] as? String
                    let profile   = dataDict[key]!["profile"] as? String
                    let userId    = dataDict[key]!["userId"] as? String
                    let userName  = dataDict[key]!["userName"] as? String
                    let timestamp = dataDict[key]!["timestamp"] as? String
                    let fcmKey    = dataDict[key]!["fcmKey"] as? String
                    
                    if senderID != userId
                    {
                        self.reciverFCMKey = fcmKey ?? ""
                    }
                    
                    let user = FirebaseUser1(email: email, profile: profile, userId: userId, userName: userName, timestamp: timestamp)
                    self.usersInfoDetailArr.append(user)
                    
                    print(user)
                    print("&&&&&&&&&&&&&&@@@@@@@@@@@@@!!!!!!!1234567890 --- \(self.usersInfoDetailArr)")
                    self.tableView.reloadData()
                }
            }
        }
        print(self.usersInfoDetailArr)
        
    }
    
    
    
    func creatRoom(){
        //        let message = sendMsgTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        //        guard !message.isEmpty else { return }
        
        guard let senderID = UserDefaults.standard.string(forKey: "userId") else { return }//Auth.auth().currentUser?.uid
        
        //        guard let senderID = Auth.auth().currentUser?.uid else { return }
        let receiverID = self.receiverId
        if receiverID == ""{
            return
        }
        let timestamp = Int(Date().timeIntervalSince1970*1000)
        let isRead = false
        let type = "individual"
        
        let request =  CreateChatRoom(senderId: senderID, receiverId: receiverID, lastMessageText: "", lastMessage: "\(timestamp)", type: type, creator: senderID, timestamp: "\(timestamp)")
        var userIdArr = [String]()
        userIdArr.append(senderID)
        userIdArr.append(receiverID)
        
        chatViewModel.createChatRoom(userIDArr: userIdArr, receiverId: receiverID, request: request, timestamp: "\(timestamp)") { result in
            print(result)
        }
    }
    
    
    
    //    private func createChatRoom(userEmail: String){
    //        var refChatRoom: DatabaseReference? = FirebaseDatabase.getInstance().reference
    //        val timestamp = ""+System.currentTimeMillis()
    //        userIdArray.add(myEmail!!)
    //        for (i in 0 until userIdArray.size){
    //            userList.add(userEmail[i])
    //        }
    //        val hash: HashMap<String, Any> = HashMap()
    //        hash["broadcat"] = false
    //        val hashMapChatRm: HashMap<String, Any> = HashMap()
    //        hashMapChatRm["users"] = userList
    //        hashMapChatRm["lastMessageText"] = ""
    //        hashMapChatRm["lastMessage"] = timestamp
    //        hashMapChatRm["type"] = "individual"
    //        hashMapChatRm["creator"] = Utility.UID
    //        hashMapChatRm["meta"] = hash
    //        refChatRoom!!.child("chatRoom").push().setValue(hashMapChatRm)
    //    }
    
    
    
    private func setUpData(){
        self.receiverName.text = self.name
        let imageUrl = URL(string: self.profilePhoto)
        self.receiverProfileImgView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "profilePlaceHolder"))
        
        self.sendMsgTxtView.placeholder = "Type a message..."
        self.sendMsgTxtView.textColor = .darkGray
        if (myChatUserDetail.meta?["broadcat"] as? Int == 1) || (myChatUserDetail.meta?["isBlockEmployee"] as? Bool == true){
            sendMessageView.isHidden = false
        }else{
            sendMessageView.isHidden = true
        }
        //getRoomId()
    }
    //MARK: Get Message From Firebase
    
    func getMessages(){
        
        self.senderId =  getFirebaseUserId() //UserDefaults.standard.string(forKey: "userId") ?? ""
        
        chatViewModel.getMessage2(roomId: self.roomId) { (messages) in
            self.messages = messages
            
            self.messages =  self.messages.sorted{$0.timestamp! < $1.timestamp!} // Sorting messages according to date
            
            NotificationCenter.default.post(name: NSNotification.Name(NotificationKeys.MESSAGE), object: nil)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print(messages.count)
                print("Scroll to bottom in chat vc")
                if self.messages.count != 0{
                    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    //       func creatRoom(){
    //           //        let message = sendMsgTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    //           //        guard !message.isEmpty else { return }
    //
    //           guard let senderID = UserDefaults.standard.string(forKey: "userId") else { return }//Auth.auth().currentUser?.uid
    //
    //   //        guard let senderID = Auth.auth().currentUser?.uid else { return }
    //           let receiverID = self.receiverId
    //           if receiverID == ""
    //           {
    //               return
    //           }
    //           let timestamp = Int(Date().timeIntervalSince1970*1000)
    //           let isRead = false
    //           let type = "individual"
    //
    //           let request =  CreateChatRoom(senderId: senderID, receiverId: receiverID, lastMessageText: "", lastMessage: "\(timestamp)", type: type, creator: senderID, timestamp: "\(timestamp)")
    //           var userIdArr = [String]()
    //           userIdArr.append(senderID)
    //           userIdArr.append(receiverID)
    //
    //           chatViewModel.createChatRoom(userIDArr: userIdArr, receiverId: receiverID, request: request, timestamp: "\(timestamp)") { result in
    //               print(result)
    //           }
    //       }
    //
    //
    ////        self.senderId = Auth.auth().currentUser?.uid ?? "0"
    ////        chatViewModel.getMessages(senderID: self.senderId, recieverID: self.receiverId) { (messages) in
    ////            self.messages = messages
    ////            NotificationCenter.default.post(name: NSNotification.Name(NotificationKeys.MESSAGE), object: nil)
    ////            DispatchQueue.main.async {
    ////                self.tblView.reloadData()
    ////                print("Scroll to bottom in chat vc")
    ////                if self.messages.count != 0
    ////                {
    ////                    self.tblView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
    ////                }
    ////            }
    ////        }
    //    }
    
    //    func getRoomId(){
    //        guard let employerId = UserDefaults.standard.string(forKey: "userId") else { return }
    //        self.senderId = employerId //Auth.auth().currentUser?.uid ?? "0"
    //        chatViewModel.getRoomId(senderID: self.senderId) { (messages) in
    //
    ////            self.messages = messages
    ////            NotificationCenter.default.post(name: NSNotification.Name(NotificationKeys.MESSAGE), object: nil)
    ////            DispatchQueue.main.async {
    ////                self.tblView.reloadData()
    ////                print("Scroll to bottom in chat vc")
    ////                if self.messages.count != 0
    ////                {
    ////                    self.tblView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
    ////                }
    ////            }
    //        }
    //    }
    
 //MARK: Work Chat Group Icon
    @IBAction func onClickGroupICon(_ sender: Any) {
        if myChatUserDetail.type == "group"{
        let vc = WorkChatGroupDetailsVC()
        vc.myChatDetail = myChatUserDetail
        self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    }
    @IBAction func onClickSend(_ sender: UIButton) {
        let message = sendMsgTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty  else { return }
        
        sender.isEnabled = false
        
        //      guard let senderId = UserDefaults.standard.string(forKey: "userId") else { return }
        let senderId = getFirebaseUserId()
        var receiverID = self.receiverId
        if myChatUserDetail.type == "group"{
            receiverID = ""
        }else{
            if receiverID == ""{
                return
            }
        }
        let roomId = self.roomId
        if roomId == ""{
            return
        }
        let type      = "text"
        let timestamp = Int(Date().timeIntervalSince1970*1000)
        self.sendNotification(message: message, image: message)
        
        //      let request = Message2(content: message, fromID: senderId, toID: receiverID, roomId: self.roomId, timestamp: "\(timestamp)", type: type)
        
        let request = MessageStruct(message: "\(message)", senderId: "\(senderId)", receiverId: "\(receiverID)", timestamp: "\(timestamp)", type: "\(type)", roomId: "\(roomId)")
        
        
        chatViewModel.sendMessage(request: request) { (conversationId) in
            //            if self.conversationId == nil{
            //                self.conversationId = conversationId
            //                self.getMessages()
            //            }
            self.getMessages()
            self.sendMsgTxtView.text = ""
            sender.isEnabled = true
        }
    }
    
    func sendNotification(message : String, image: String) {
                let sender = PushNotificationSender()
        let name = getEmployeeName()
        let serverKey = FCM_SERVER_KEY
        let token = self.reciverFCMKey
        
        if token != "" {
            sender.sendPushNotification(to: token , title: "New Message from \(name ?? "")", body: message, email : "", queryID : "", image: image,fcmServerKey: serverKey)
        }
    }
    
    
    @objc func handleKeyboard(_ notification: Notification){
        
        if notification.name == UIResponder.keyboardWillShowNotification{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let bottomSafeArea = view.safeAreaInsets.bottom
                self.messageViewBottomConstraint.constant = keyboardHeight - bottomSafeArea
                if messages.count != 0{
                    DispatchQueue.main.async {
                        self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                    }
                }
            }
        }else if notification.name == UIResponder.keyboardWillHideNotification{
            self.messageViewBottomConstraint.constant = 0
        }
    }
    
    @IBAction func onClickPickImage(){
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let CameraAction = UIAlertAction(title: "Camera", style: .default, handler:
                                            {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        let LibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler:
                                            {
            (alert: UIAlertAction!) -> Void in
            self.openGallery()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
                                            {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(CameraAction)
        optionMenu.addAction(LibraryAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    // Opening camera
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // Opening Gallery
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType =   .photoLibrary//.savedPhotosAlbum
            
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //    func sendmessages(message: String, receiverId:String,roomId:String, type: String) {
    //
    //        let message = message
    //        guard !message.isEmpty else { return }
    //        guard let senderId = UserDefaults.standard.string(forKey: "userId") else { return }
    //        let timestamp = Int(Date().timeIntervalSince1970*1000)
    //
    //        let request = Message2(content: message, fromID: senderId, toID: receiverId, roomId: roomId, timestamp: "\(timestamp)", type: type)
    //
    //        self.sendNotification(message: message, image: message)
    //        chatViewModel.sendMessage(request: request) { (conversationId) in
    //            //            if self.conversationId == nil{
    //            //                self.conversationId = conversationId
    //            //                self.getMessages()
    //            //            }
    //            self.getMessages()
    //            self.sendMsgTxtView.text = ""
    //        }
    //    }
    
    //MARK:- UPDATE profile photo API
    func UPDATEprofile(imagepath : UIImage,isType : String,docurl : String){
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(self.view)
            
            //            let fileNames = "file"
            //            //            let teacherphotoUrl = URL(string: imagepath)
            //            //           print(teacherphotoUrl!)
            //            let param:[String:String] = [:]
            //
            //
            //
            //            ServerClass.sharedInstance.sendMultipartRequestFROMCHAT(urlString: BASE_URL + PROJECT_URL.UPLOAD_FILE_CHAT, fileNames: isType, param, imageUrl: imagepath ,docurl : docurl, successBlock: { (json) in
            //
            //                print(json)
            //
            //                hideProgressOnView(self.view)
            //                let success = json["code"].stringValue
            //                if success  == "E0000"
            //                {
            //
            //                    let file = json["file"].stringValue
            //                    self.sendmessages(message: file, type: isType)
            //                }
            //                else {
            //                    UIAlertController.showInfoAlertWithTitle("Message", message: json["frontendmessage"].stringValue, buttonTitle: "Okay")
            //                }
            //            }, errorBlock: { (NSError) in
            //                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
            //                hideProgressOnView(self.view)
            //            })
            
        }else{
            hideProgressOnView(self.view)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
}
//MARK: Table View Delegate and Data Source

extension WorkChatDetailsChatVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let senderId = Auth.auth().currentUser?.uid
        let senderId = getFirebaseUserId() //UserDefaults.standard.string(forKey: "userId") ?? ""
        
        let message = messages[indexPath.row]
        
        if message.fromID == senderId{
            if message.type == "image" {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as? SenderImageCell else{return UITableViewCell()}
                cell.delegate = self
                cell.message = message
                // Find the index of the user detail in the array
                if let index = self.usersInfoDetailArr.firstIndex(where: { $0.userId == senderId }) {
                    let info = self.usersInfoDetailArr[index]
                    cell.userInfo = info
                }
                return cell
            }else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as? SenderCell else{return UITableViewCell()}
                cell.message = message
                
                // Find the index of the user detail in the array
                if let index = self.usersInfoDetailArr.firstIndex(where: { $0.userId == senderId }) {
                    let info = self.usersInfoDetailArr[index]
                    cell.userInfo = info
                    
                }
                return cell
            }
        }
        else{
            if message.type == "image" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImageCell", for: indexPath) as? ReceiverImageCell else{return UITableViewCell()}
                cell.delegate = self
                cell.message = message
                // Find the index of the user detail in the array
                if let index = self.usersInfoDetailArr.firstIndex(where: { $0.userId == message.fromID }) {
                    let info = self.usersInfoDetailArr[index]
                    cell.userInfo = info
                }
                return cell
            }else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as? ReceiverCell else{return UITableViewCell()}
                cell.message = message
                // Find the index of the user detail in the array
                if let index = self.usersInfoDetailArr.firstIndex(where: { $0.userId == message.fromID }) {
                    let info = self.usersInfoDetailArr[index]
                    cell.userInfo = info
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
    }
    
}
//MARK:- imagePickerController delegate methods
extension WorkChatDetailsChatVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[.originalImage] as? UIImage {
            
            
            // Step 1: Convert the picked image to data
            guard let imageData = pickedImage.jpegData(compressionQuality: 0.8) else {
                print("Failed to convert image to data.")
                return
            }
            
            deleteDirectory(name: "temp.jpeg")
            let pickedImageUrl = getImageUrl()
            
            
            // self.profileimg.image = pickedImage
            let imgUrlStr = String(describing: pickedImageUrl!)
            print("\(imgUrlStr)")
            
            
            saveImageDocumentDirectory(usedImage: pickedImage)
            //UPDATEprofile(imagepath : pickedImage, isType: "image", docurl: "")
            // update profile from firebase
            
            
            
            guard let senderId = UserDefaults.standard.string(forKey: "userId") else { return }
            var receiverID = self.receiverId
            
            if myChatUserDetail.type == "group"{
                receiverID = ""
            }else{
                if receiverID == ""{
                    return
                }
            }
            
            let roomId = self.roomId
            if roomId == ""{
                return
            }
            let type      = "image"
            let timestamp = Int(Date().timeIntervalSince1970*1000)
            self.sendNotification(message: sendMsgTxtView.text!, image: "")
            
            //            let request = Message2(content: "\(pickedImage)", fromID: senderId, toID: receiverID, roomId: self.roomId, timestamp: "\(timestamp)", type: type)
            
            let request = MessageStruct(message: "\(pickedImage)", senderId: "\(senderId)", receiverId: "\(receiverID)", timestamp: "\(timestamp)", type: "\(type)", roomId: "\(roomId)")
            
//            let request = MessageStruct(message: "\(pickedImage)", senderId: "", receiverId: "", timestamp: "", type: "\(type)", roomId: "")
            
            print(request)
            
            chatViewModel.uploadImageURLToFirebase(request: request, imageURL: imageData, onSuccess: { (result) in
                print(result)
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func sendmessages(message: String, receiverId:String,roomId:String, type: String) {
        
        let message = message
        guard !message.isEmpty else { return }
        guard let senderId = UserDefaults.standard.string(forKey: "userId") else { return }
        let timestamp = Int(Date().timeIntervalSince1970*1000)
        
        let request = Message2(content: message, fromID: senderId, toID: receiverId, roomId: roomId, timestamp: "\(timestamp)", type: type)
        
        print(request)
        
        self.sendNotification(message: message, image: message)
        //                chatViewModel.sendMessage(request: request) { (conversationId) in
        //                    //            if self.conversationId == nil{
        //                    //                self.conversationId = conversationId
        //                    //                self.getMessages()
        //                    //            }
        //                    self.getMessages()
        //                    self.sendMsgTxtView.text = ""
        //                }
        //
        
        
        
        
        
        //        let message = message
        //        guard !message.isEmpty else { return }
        //
        //        guard let fromId = Auth.auth().currentUser?.uid else { return }
        //        guard let toId = self.user?.uid else { return }
        //        let timestamp = Int(Date().timeIntervalSince1970*1000)
        //        let isRead = false
        //        let type = type
        //
        //        let request = Message(content: message, fromID: fromId, timestamp: "\(timestamp)", isRead: isRead, toID: toId, type: type,queryId: "")
        //        self.sendNotification(message: message, image: message)
        //        chatViewModel.sendMessage(request: request) { (conversationId) in
        ////            if self.conversationId == nil{
        ////                self.conversationId = conversationId
        ////                self.getMessages()
        ////            }
        //            self.getMessages()
        //            self.sendMsgTxtView.text = ""
        //        }
    }
}
//MARK: Text View Delegates
extension WorkChatDetailsChatVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.textColor = .lightGray
            textView.placeholder = "Type something..."
        }
    }
}
//MARK: Access Sender and Receiver ImageCell by delegate
extension WorkChatDetailsChatVC:SenderImageCellDelegate,ReceiverImageCellDelegate{
    func onTapImage(cell: SenderImageCell) {
        print(cell.message?.content)
        guard let cellImageUrl = cell.message?.content else{return}
        ImageUrlStr = cellImageUrl
        showImgCustomPopUp()
    }
    func onTapImage(cell: ReceiverImageCell) {
        print(cell.message?.content)
        guard let cellImageUrl = cell.message?.content else{return}
        ImageUrlStr = cellImageUrl
        showImgCustomPopUp()
    }
    func showImgCustomPopUp(){
        self.imagePopUp = WCViewImagePopUp(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(self.imagePopUp)
    }
    
}
