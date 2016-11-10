//
//  ViewController.swift
//  BusLocation
//
//  Created by Charles Julian Knight on 11/7/16.
//  Copyright © 2016 FIXD Automotive Inc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let api = Api()
    let disposeBag = DisposeBag()
    
    let route = "21"

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var hasZoomedToUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            fallthrough
        case .restricted:
            locationNotAvailable()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            requestLocation()
        }
        
        Observable<Int>.timer(5.0, scheduler: MainScheduler.instance) //ConcurrentDispatchQueueScheduler(qos: .utility)
            .flatMap { _ in
                return self.api.getBusInfo(route: self.route).catchError { err -> Observable<[BusLocation]> in
                    print("problem loading data! \(err)")
                    return Observable.empty()
                }
            }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext:{ busLocations in
                //self.map.removeOverlays(self.map.overlays)
                self.map.removeAnnotations(self.map.annotations)
                for busLocation in busLocations {
                    //self.map.add(busLocation.toOverlay())
                    self.map.addAnnotation(busLocation.toAnnotation())
                }
            }).addDisposableTo(disposeBag)
    }
    
    func locationNotAvailable(){
        let alert = UIAlertController(title: "Location Permission Required", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil) }))
        alert.show(self, sender: self)
    }
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location auth status: \(status)")
        switch status {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            requestLocation()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationNotAvailable()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let cord = locations.first?.coordinate, !hasZoomedToUser {
            print("locations: \(locations)")
            
            if !map.isUserLocationVisible {
                //map.setCenter(cord, animated: true)
                
                map.setRegion(MKCoordinateRegion(center: cord, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
            }
            
            hasZoomedToUser = true
        }
    }
    
    func requestLocation(){
        map.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }

}

extension BusLocation {
    
    fileprivate var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    //fileprivate func toOverlay() -> MKOverlay {
    //}
    
    fileprivate func toAnnotation() -> MKAnnotation {
        let p = MKPointAnnotation()
        p.coordinate = self.location
        p.title = self.vehicle
        p.subtitle = "Heading \(self.direction.rawValue), \(self.adherance)"
        return p
    }
    
}
