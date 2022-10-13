//
//  StompMessageHub.swift
//  FPEU
//
//  Created by son on 11/10/2022.
//

import Foundation
import StompClientLib
import RxSwift

enum WSMessageCode: Int{
    case orderCompleted = 0
    case newOrder = 1
    case foundDriver = 2
    case cancelOrder = 3
    case deliveringOrderToCustomer = 5
    case driverArrived = 6
    case unknown = -1
}

struct WSMessage {
    let code: Int
    let body: String
    
    func getCode() -> WSMessageCode {
        return WSMessageCode.init(rawValue: code) ?? .unknown
    }
    
    func getBody<T: Decodable>() -> T? {
        let decoder = JSONDecoder()
        do {
            if let data = body.data(using: .unicode) {
                return try decoder.decode(T.self, from: data)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
}

class StompMessageHub {
    
    let socketClient = StompClientLib()
    
    private var endpointListenerMap = [String:PublishSubject<WSMessage>]()
    private var sharedObservablerMap = [String:Observable<WSMessage>]()
    
    private init() {
        
    }
    
    func connectToSocket() {
        let url = NSURL(string: ServiceUrl.wssUrl)!
        let jwt = UserDataDefaults.shared.jwtToken
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self, connectionHeaders: ["Authorization" : "Bearer \(jwt)"])
    }
    
    public func subscribe(to endpoint: String) -> Observable<WSMessage> {
        if let messageStream = sharedObservablerMap[endpoint] {
            return messageStream
        } else {
            let subject = PublishSubject<WSMessage>()
            sharedObservablerMap[endpoint] = subject.share()
            endpointListenerMap[endpoint] = subject
            return subject
        }
        
    }
    
    static let shared = StompMessageHub()
}

extension StompMessageHub: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        if let subject = endpointListenerMap[destination] as? PublishSubject<WSMessage>, let wsMessage = jsonBody as? WSMessage {
            subject.onNext(wsMessage)
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        
    }
    
    func serverDidSendPing() {
        
    }
    
    
}