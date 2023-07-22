//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Emirhan Cankurt on 2.02.2023.
//

import UIKit
import Parse

struct Objects {
    var placeNameText :String
    var placeIdArray :String
    
}

class PlacesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alldata = [Objects]()
    var selecteddata : Objects?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tumKelimelerAl()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                self.performSegue(withIdentifier: "toSignUPVc", sender: nil)
            }
        }
    }
    
    
    @IBAction func addClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
        
    }
    
    func tumKelimelerAl() {
        
        let query = PFQuery(className:"object")
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            } else {
                if let objects = objects {
                    
                    self.alldata.removeAll(keepingCapacity: false)
                    
                    for object in objects {
                        if let placename = object.object(forKey: "placeNameText") as? String , let objectId = object.objectId {
                            
                            let informations = Objects(placeNameText: placename, placeIdArray: objectId)
                            self.alldata.append(informations)
                            
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
}






extension PlacesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alldata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = alldata[indexPath.row].placeNameText
        cell.contentConfiguration = content
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selecteddata = alldata[indexPath.row]
        performSegue(withIdentifier: "placesVCtoDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placesVCtoDetailsVC" {
            let destinationVC = segue.destination as? DetailsVc
            destinationVC?.chosenData = selecteddata
        }
    }
    
}



