////
////  ViewController.swift
////  FPEU
////
////  Created by son on 07/08/2022.
////
//
//import UIKit
//import Alamofire
//import RxSwift
//import StompClientLib
//import GoogleMaps
//
//class HomeViewController1: FPViewController {
//
//    var socketClient = StompClientLib()
//    var jwt = ""
//    let username = "son1"
//    var count = 0
//
//
//    let viewModel = HomeViewModel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//
////        FPNetwork.singlePost(endpoint: "/auth/login", params: [
////            "username": username,
////            "password": "123456"
////        ]).subscribe() {(response: LoginResponse?) in
////            self.jwt = response?.jwtToken ?? ""
////            let url = NSURL(string: ServiceUrl.wssUrl)!
////            self.socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self, connectionHeaders: ["Authorization" : "Bearer \(self.jwt)"])
////
////        } onFailure: { _ in
////
////        }
//
//
//        // Do any additional setup after loading the view.
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
////        let camera = GMSCameraPosition.camera(withLatitude: 21.029057, longitude: 105.788010, zoom: 15)
////        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
////        self.view.addSubview(mapView)
////
////        // Creates a marker in the center of the map.
////        let marker = GMSMarker()
////        marker.position = CLLocationCoordinate2D(latitude: 21.029057, longitude: 105.788010)
////        marker.title = "Sydney"
////        marker.snippet = "Australia"
////        let icon = UIImage(named: "ned")
////        marker.icon = icon
////        marker.map = mapView
//
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.navigationController?.isNavigationBarHidden = true
//
//        if UserDataDefaults.shared.isLoggedIn {
//            viewModel.inLoadHomeInfo.accept(())
//        } else {
//           showLoginScreen()
//        }
//
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//    }
//
//
//    private func bindViewModel() {
//        viewModel.outHomeInfo.asObservable().subscribe().disposed(by: disposeBag)
//    }
//
//    @IBAction func sendBtnTapped(_ sender: Any) {
//        socketClient.sendMessage(message: "{\"username\":\"son\", \"message\":\"Hello samsung\(count)\"}", toDestination: "/app/hello", withHeaders: ["content-type":"application/json;charset=UTF-8"], withReceipt: nil)
//        count+=1
//    }
//}
//
//class HelloMsg: NSObject {
//    var name: String = ""
//
//    init(name: String) {
//        self.name = name
//    }
//}
//
//extension HomeViewController: StompClientLibDelegate {
//    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
//        print("Destination : \(destination)")
//        print("JSON Body : \(String(describing: jsonBody))")
//        print("String Body : \(stringBody ?? "nil")")
//
//       let text = "Destination : \(destination)\nJSON Body : \(String(describing: jsonBody))\nString Body : \(stringBody ?? "nil")"
//
//
//    }
//
//    func stompClientDidDisconnect(client: StompClientLib!) {
//
//    }
//
//    func stompClientDidConnect(client: StompClientLib!) {
//        print("Socket is connected")
//        socketClient.subscribe(destination: "/users/queue/messages")
//    }
//
//    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
//
//    }
//
//    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
//        print("Error Send : \(String(describing: message))")
//
//    }
//
//
//    func serverDidSendPing() {
//        print("Server ping")
//    }
//
//}
//
