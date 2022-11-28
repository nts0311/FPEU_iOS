//
//  DriverTrackingViewController.swift
//  FPEU
//
//  Created by son on 28/11/2022.
//

import UIKit
import GoogleMaps

class DriverTrackingViewController: FPViewController {

    @IBOutlet weak var mapContainerView: UIView!
    
    private var mapView: GMSMapView?
    private var marker: GMSMarker?
    
    private let viewModel = DriverTrackingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        bindViewModel()
        viewModel.getDriverLocationFlow()
    }


    private func setupViews() {
        navigationItem.title = "Theo dõi tài xế"
        initMap()
    }
    
    private func bindViewModel() {
        viewModel.driverLocation.subscribe(onNext: {driverLocation in
            self.onNewDriverLocation(lat: driverLocation.lat, lng: driverLocation.lng)
        }).disposed(by: disposeBag)
    }
    
    private func initMap() {
        let lat = UserRepo.shared.currentUserAddress?.lat ?? 0.0
        let lng = UserRepo.shared.currentUserAddress?.lng ?? 0.0
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: mapContainerView.bounds, camera: camera)
       // mapView?.delegate = self
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapContainerView.addSubview(mapView!)
    }
    
    private func onNewDriverLocation(lat: Double, lng: Double) {
        if let marker {
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        } else {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            marker.icon = UIImage(named: "ned")
            marker.map = mapView
            
            self.marker = marker
        }
        
        guard let mapView, let marker else {
            return
        }
        
        var point = mapView.projection.point(for: marker.position)
        let camera = mapView.projection.coordinate(for: point)
        let position = GMSCameraUpdate.setTarget(camera)
        mapView.animate(with: position)
    }

}

extension DriverTrackingViewController {
    static func showOn(_ navController: UINavigationController?) {
        let vc = DriverTrackingViewController.initFromNib()
        navController?.pushViewController(vc, animated: true)
    }
}
