//
//  AddPlaceVc.swift
//  FoursquareClone
//
//  Created by Emirhan Cankurt on 9.02.2023.
//

import UIKit
import Parse
import ParseSwift

class AddPlaceVc: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeNameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    
    @IBOutlet weak var placeAtmosphereText: UITextField!
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        placeImageView.addGestureRecognizer(imageTapRecognizer)

    }
    

    @objc func selectImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    

    @IBAction func nextButtonClicked(_ sender: Any) {
        //Veriler PlaceModel'a aktarıldı
        
        if let placeisim = placeNameText.text , let placeTipi = placeTypeText.text , let placeatmosfer = placeAtmosphereText.text  ,let placeresim = placeImageView.image {
            PlaceModel.sharedInstance.placeName = placeisim
            PlaceModel.sharedInstance.placeType = placeTipi
            PlaceModel.sharedInstance.placeAtmosphere = placeatmosfer
            PlaceModel.sharedInstance.placeImage = placeresim
            
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            print("error!")
        }

    }

    
}
