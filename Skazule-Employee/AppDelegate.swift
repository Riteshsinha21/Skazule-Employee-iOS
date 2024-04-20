//
//  AppDelegate.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 1/30/23.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var fcmToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        IQKeyboardManager.shared.enable = true
        
        
        // Configure Firebase
         FirebaseApp.configure()
        Messaging.messaging().delegate = self
//        FirebaseConfiguration.shared.setLoggerLevel(.min)
        setupRemotePushNotifications()
        
        if getIsLogin() == nil{
            saveIsLogin(isLogin: false)
        }
        (getIsLogin() == true) ?  initialiseAppWithController(loadTabBar()) :  initialiseAppWithController(LoginVC())
        
        return true
    }

    
    
    
    
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("user npt")
        
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
        }
        
//        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
//
//            let deepLink = userInfo["gcm.notification.deepLink"] as? String ?? ""
//            let email = userInfo["google.c.sender.id"] as? String ?? ""
//            let queryID = userInfo["gcm.notification.queryID"] as? String ?? ""
//
//            print("body string: \(deepLink) \( email)")
//
//
//            DispatchQueue.main.async{
//
//                if deepLink == "LEAD" {
//
//                    guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
//                        return
//                    }
//
//                    let storyboard = UIStoryboard(name: "LeadStoryboard", bundle: nil)
//
//
//                    if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "LeadListVC") as? LeadListVC,
//                        let tabBarController = rootViewController as? UITabBarController,
//                        let navController = tabBarController.selectedViewController as? UINavigationController {
//
//                        navController.pushViewController(conversationVC, animated: true)
//                    }
//
//                }
//                else if deepLink == "USER" {
//
//                    guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
//                        return
//                    }
//
//                    let storyboard = UIStoryboard(name: "Customer", bundle: nil)
//
//
//                    if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "CustomerVC") as? CustomerVC,
//                        let tabBarController = rootViewController as? UITabBarController,
//                        let navController = tabBarController.selectedViewController as? UINavigationController {
//
//                        navController.pushViewController(conversationVC, animated: true)
//                    }
//
//                }else if deepLink == "PROPOSAL" {
//
//                    guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
//                        return
//                    }
//
//                    let storyboard = UIStoryboard(name: "Proposals", bundle: nil)
//
//
//                    if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "ProposalVC") as? ProposalVC,
//                        let tabBarController = rootViewController as? UITabBarController,
//                        let navController = tabBarController.selectedViewController as? UINavigationController {
//
//                        navController.pushViewController(conversationVC, animated: true)
//                    }
//
//                }
//            }
//            /*
//             else if deepLink == "PROFILE" {
//
//                 guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
//                     return
//                 }
//
//                 let storyboard = UIStoryboard(name: "LeadStoryboard", bundle: nil)
//
//
//                 if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "LeadListVC") as? LeadListVC,
//                     let tabBarController = rootViewController as? UITabBarController,
//                     let navController = tabBarController.selectedViewController as? UINavigationController {
//
//                     navController.pushViewController(conversationVC, animated: true)
//                 }
//
//             }
//             */
//
//        }
        completionHandler()
    }
}

extension AppDelegate {
    private func setupRemotePushNotifications() {
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { [weak self] granted, error in
                if granted {
                    self?.getNotificationSettingsAndRegister()
                } else {
                    print(" error")
                }
            })

        Messaging.messaging().delegate = self

        UIApplication.shared.registerForRemoteNotifications()

        processPushToken()
    }

    private func getNotificationSettingsAndRegister() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    private func processPushToken() {
        if let token = Messaging.messaging().fcmToken {
            print("FCM TOKEN \(token)")
            saveFCMKey(fcmKey: token)
  //          UserDefaults.standard.set(token, forKey: USER_DEFAULTS_KEYS.FCM_KEY)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
            print("FdeviceToken: \(UIDevice.current.identifierForVendor!.uuidString)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

public extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        processPushToken()
    }
}

