//
//  DetailsVc.swift
//  FoursquareClone
//
//  Created by Emirhan Cankurt on 9.02.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVc: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    var locationManager = CLLocationManager()
    
    var chosenData : Objects?
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsMapView.delegate = self
        
        getDataFromParse()
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "object")
        query.whereKey("objectId", equalTo: chosenData!.placeIdArray)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                print("error")
            } else {
                if let objects = objects {
                    let chosenPlaceObject = objects[0]
                    
                    // OBJECTS
                    
                    if let placeName = chosenPlaceObject.object(forKey: "placeNameText") as? String {
                        self.detailsNameLabel.text = placeName
                    }
                    
                    if let placeType = chosenPlaceObject.object(forKey: "placeTypeText") as? String {
                        self.detailsTypeLabel.text = placeType
                    }
                    
                    if let placeAtmosphere = chosenPlaceObject.object(forKey: "placeAtmosphereText") as? String {
                        self.detailsAtmosphereLabel.text = placeAtmosphere
                    }
                    
                    if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                        if let placeLatitudeDouble = Double(placeLatitude){
                            self.chosenLatitude = placeLatitudeDouble
                        }
                    }
                    
                    if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                        if let placeLongitudeDouble = Double(placeLongitude){
                            self.chosenLongitude = placeLongitudeDouble
                        }
                    }
                    
                    if let imageData = chosenPlaceObject.object(forKey: "imageFile") as? PFFileObject {
                        imageData.getDataInBackground { (data, error) in
                            if error != nil {
                                print(error?.localizedDescription ?? "Error")
                            } else {
                                self.detailsImageView.image = UIImage(data: data!)
                            }
                        }
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = self.detailsNameLabel.text
                    annotation.subtitle = self.detailsTypeLabel.text
                    let coordinate = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    annotation.coordinate = coordinate
                    
                    self.detailsMapView.addAnnotation(annotation)
                    self.locationManager.stopUpdatingLocation()
                    
                    let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    self.detailsMapView.setRegion(region, animated: true)
                    
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                    
                }
            }
            
        }
    }
    
}










