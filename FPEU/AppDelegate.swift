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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDDBPyCwVvmdpEgm6XHS-9nCjkHpXfGqwI")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        NotificationCenter.default.rx.notification(.sessionExpired)
            .debounce(RxTimeInterval.milliseconds(200), scheduler: globalScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {_ in
                UserDataDefaults.shared.jwtToken = nil
                UserDataDefaults.shared.isLoggedIn = false
                UIViewController.topMostViewController()?.showLoginScreen()
            })
            .disposed(by: disposeBag)
        
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


}

