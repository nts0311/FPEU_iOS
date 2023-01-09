//
//  SearchLocationViewController.swift
//  FPEU
//
//  Created by son on 24/10/2022.
//

import UIKit
import GooglePlaces
import GoogleMaps

class AddAddressViewController: FPViewController {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapContainer: UIView!
    
    @IBOutlet weak var nameTextView: UITextField!
    var mapView: GMSMapView? = nil
    var currentAddress: FPAddress? = nil
    var isSelectedFromPlace = true
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Thêm địa chỉ mới"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchTapped2(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.addressComponents.rawValue) |  UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.countries = ["VN"]
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func addAddressTapped(_ sender: Any) {
        currentAddress?.name = nameTextView.text
        FPNetwork.singlePost(FPBaseResponse.self, endpoint: Endpoint.addLocation, params: currentAddress.dictionary ?? [:])
            .catchErrorJustComplete()
            .subscribe(onNext: {_ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func displayAddressContent() {
        guard let address = currentAddress else {
            return
        }
        
        addressLabel.textColor = .black
        addressLabel.text = address.toString()
    }
    
    private func displayAddress() {
        guard let address = currentAddress else {
            return
        }
        
        displayAddressContent()
        
        if let lat = address.lat, let lng = address.lng {
            if (mapView != nil) {
                mapView?.removeFromSuperview()
            }
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 16.0)
            mapView = GMSMapView.map(withFrame: mapContainer.bounds, camera: camera)
            mapView?.delegate = self
            mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapContainer.addSubview(mapView!)
        }
        
    }
    
}

extension AddAddressViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
        if (isSelectedFromPlace) {
            isSelectedFromPlace = false
            return
        }
        
        let geodecoder = GMSGeocoder()
        geodecoder.reverseGeocodeCoordinate(cameraPosition.target) { response, error in
            if let result = response?.firstResult() {
                self.currentAddress = FPAddress(address: result)
                self.displayAddressContent()
            }
        }
    }
}

extension AddAddressViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
            
        currentAddress = FPAddress()
        currentAddress?.ward = place.addressComponents?.first(where: {$0.types.contains("sublocality")})?.name
        currentAddress?.district = place.addressComponents?.first(where: {$0.types.contains("administrative_area_level_2")})?.name
        currentAddress?.city = place.addressComponents?.first(where: {$0.types.contains("administrative_area_level_1")})?.name
        currentAddress?.detail = place.name
        currentAddress?.lat = place.coordinate.latitude
        currentAddress?.lng = place.coordinate.longitude
        
        displayAddress()
        isSelectedFromPlace = true
            
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
