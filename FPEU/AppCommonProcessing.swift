//
//  AppCommonProcessing.swift
//  FPEU
//
//  Created by son on 30/10/2022.
//

import Foundation
import UIKit

class AppCommonProcessing {
    private init() {}
    static let shared = AppCommonProcessing()
    
    func onCurrentOrderCanceled(reason: String) {
        guard let topVc = UIApplication.topViewController() as? FPViewController else { return }
        
        topVc.showAlertDialog(title: "Thông báo", message: "Rất tiếc, đơn hàng của bạn đã bị huỷ. Lý do: \(reason). Hãy đặt đơn mới bạn nhé!", firstActionTitle: "OK", firstAction: {
            if (topVc is OrderTrackingViewController) {
                topVc.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func uploadFcmToken(fcmToken: String) {
        FPNetwork.post(endpoint: Endpoint.updateFcmToken, params: ["fcmToken" : fcmToken]) { data in
            
        } failure: { code, message in
            
        } timeout: { message in
            
        }
    }
    
}
