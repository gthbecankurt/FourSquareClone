//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Emirhan Cankurt on 29.01.2023.
//

import UIKit
import Parse



class SignUPVc: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        if userNameTextField.text != "" && passwordTextField.text != "" {
            PFUser.logInWithUsername(inBackground: userNameTextField.text!, password: passwordTextField.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                }
                self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
            }
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Username/password?")
        }

    }
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        if userNameTextField.text != "" && passwordTextField.text != "" {
            let user = PFUser()
            user.username = userNameTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground { sucess, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    //segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
            
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Username/password?")
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}




