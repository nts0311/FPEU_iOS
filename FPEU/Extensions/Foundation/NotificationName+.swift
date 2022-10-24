//
//  NotificationName+.swift
//  FPEU
//
//  Created by son on 08/08/2022.
//

import Foundation

public extension Notification.Name {
    static let sessionExpired = Notification.Name(rawValue: "sessionExpired")
    static let loggedIn = Notification.Name(rawValue: "loggedIn")
    static let changeCurrentAddress = Notification.Name(rawValue: "changedCurrentAddress")
}
