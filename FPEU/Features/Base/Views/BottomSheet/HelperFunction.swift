//
//  HelperFunction.swift
//  CoreUtilsKit
//
//  Created by Bui Thien Thien on 8/7/20.
//  Copyright © 2020 ViettelPay App Team. All rights reserved.
//

import Foundation
import UIKit

public class HelperFunction {
    
    public static func appVersion(_ bundle: Bundle = .main) -> String {
        let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        return appVersion ?? ""
    }
    
    public static func makeACall(to phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    public static func getImage(named: String, in bundle: Bundle) -> UIImage? {
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
}

// MARK: - Navigation Bars
public extension HelperFunction {
    static func isIPhoneX() -> Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0.0 > 20.0
        }
        
        return false
    }
    
    static func heightNavigationBar() -> CGFloat {
        return isIPhoneX() ? 88.0 : 64.0
    }
    
    static func heightSafeAreaTop() -> CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 20.0
        }
        
        return 20.0
    }
    
    static func paddingTopWithSafeArea() -> CGFloat {
        return heightNavigationBar() - heightSafeAreaTop()
    }
}

// MARK: Bottomsheet
public extension HelperFunction {
    static func getTwoEdgesRoundCornerLayer(view: UIView, cornerRadius:CGFloat) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        return maskLayer
    }
}
// MARK: - Bank Card
public extension HelperFunction {
    static func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    static func formatCardNumber(_ input: String) -> String {
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        var formatted = ""
        var formatted4 = ""
        for character in numberOnly {
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4
        return formatted
    }
}

// MARK: - Read Json File
public extension HelperFunction {
    static func readJsonFile(_ name: String, bundle: Bundle = Bundle(for: HelperFunction.self)) -> Data? {
        if let path = bundle.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                debugPrint("parse error: \(error.localizedDescription)")
                return nil
            }
        }
        debugPrint("Invalid filename/path.")
        return nil
    }
}

// MARK: - Get bundle from Bundle Resource
public extension HelperFunction {
    static func getBundle<T: UIView>(for view: T.Type, bundleResource: String) -> Bundle {
        if let path = Bundle(for: view.self).path(forResource: bundleResource, ofType: "bundle"),
           let bundle = Bundle(path: path) {
            return bundle
        } else {
            return .main
        }
    }

    static func getBundle<T: UIViewController>(for viewController: T.Type, bundleResource: String) -> Bundle {
        if let path = Bundle(for: viewController.self).path(forResource: bundleResource, ofType: "bundle"),
           let bundle = Bundle(path: path) {
            return bundle
        } else {
            return .main
        }
    }
}

