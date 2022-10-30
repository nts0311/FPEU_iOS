//
//  AppDelegate.swift
//  FPEU
//
//  Created by son on 07/08/2022.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import RxSwift
import GooglePlaces
import FirebaseCore
import FirebaseMessaging

let GoogleMapKey = "AIzaSyAQ_DgW4JkqZXL2rg0XuT8TuxW81ewVulc"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    var fcmToken = ""
    
    private let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey(GoogleMapKey)
        GMSPlacesClient.provideAPIKey(GoogleMapKey)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        Messaging.messaging().delegate = self
        
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        StompMessageHub.shared
        registerNotificationListener()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // [START receive_message]
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        return UIBackgroundFetchResult.newData
    }
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        if let fcmToken = fcmToken {
            self.fcmToken = fcmToken
            AppCommonProcessing.shared.uploadFcmToken(fcmToken: fcmToken)
        }
        
    }
    
    // [END refresh_token]

}

extension AppDelegate {
    func registerNotificationListener() {
        NotificationCenter.default.rx.notification(.sessionExpired)
            .debounce(RxTimeInterval.milliseconds(200), scheduler: globalScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {_ in
                UserDataDefaults.shared.jwtToken = nil
                UserDataDefaults.shared.isLoggedIn = false
                UIViewController.topMostViewController()?.showLoginScreen()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.loggedIn)
            .debounce(RxTimeInterval.milliseconds(200), scheduler: globalScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {_ in
                if (self.fcmToken != "") {
                    AppCommonProcessing.shared.uploadFcmToken(fcmToken: self.fcmToken)
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.orderCanceled)
            .subscribe(onNext: {noti in
                let reason = noti.userInfo?["reason"] as? String ?? ""
                AppCommonProcessing.shared.onCurrentOrderCanceled(reason: reason)
            })
            .disposed(by: disposeBag)
    }
}

