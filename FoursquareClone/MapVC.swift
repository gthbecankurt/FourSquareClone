//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Emirhan Cankurt on 9.02.2023.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
        
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
         
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    @IBAction func SaveClicked(_ sender: Any) {
        
        
        let object = PFObject(className:"object")
        object["placeNameText"] =  PlaceModel.sharedInstance.placeName
        object["placeTypeText"] =  PlaceModel.sharedInstance.placeType
        object["placeAtmosphereText"] =  PlaceModel.sharedInstance.placeAtmosphere
        object["latitude"] = PlaceModel.sharedInstance.placeLatitude
        object["longitude"] = PlaceModel.sharedInstance.placeLongitude
        
        if let imageData = PlaceModel.sharedInstance.placeImage.jpegData(compressionQuality: 0.5) {
            let uuuid = UUID().uuidString
            let imageFile = PFFileObject(name:"\(uuuid).png", data:imageData)
            object["imageFile"] = imageFile
            
            object.saveInBackground { success, error in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                } else {
                    self.performSegue(withIdentifier: "fromMapVctoPlacesVC", sender: nil)
                }
            }
        } else {
            print(LocalizedError.self)
            print("basarısız")
        }
    }
}
