//
//  ViewController.swift
//  FPEU
//
//  Created by son on 07/08/2022.
//

import UIKit
import Alamofire
import RxSwift
import StompClientLib

class ViewController: UIViewController {
    
    var socketClient = StompClientLib()
    var jwt = ""
    let username = "son"
    
    @IBOutlet weak var label: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        FPNetwork.singlePost(endpoint: "/auth/login", params: [
            "username": username,
            "password": "123456"
        ]).subscribe() {(response: LoginResponse?) in
            self.jwt = response?.jwtToken ?? ""
            let url = NSURL(string: "ws://localhost:8081/stomp")!
            self.socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self, connectionHeaders: ["Authorization" : "Bearer \(self.jwt)"])
            
        } onFailure: { _ in
            
        }
        
    }


    @IBAction func sendBtnTapped(_ sender: Any) {
        socketClient.sendMessage(message: "{\"name\":\"son\"}", toDestination: "/app/hello", withHeaders: ["content-type":"application/json;charset=UTF-8"], withReceipt: nil)
    }
}

class HelloMsg: NSObject {
    var name: String = ""
    
    init(name: String) {
        self.name = name
    }
}

extension ViewController: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("Destination : \(destination)")
        print("JSON Body : \(String(describing: jsonBody))")
        print("String Body : \(stringBody ?? "nil")")
        
        label.text = "Destination : \(destination)\nJSON Body : \(String(describing: jsonBody))\nString Body : \(stringBody ?? "nil")"
        
        
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
        socketClient.subscribe(destination: "/users/queue/messages")
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error Send : \(String(describing: message))")
        
    }
    
    
    func serverDidSendPing() {
        print("Server ping")
    }
    
}

