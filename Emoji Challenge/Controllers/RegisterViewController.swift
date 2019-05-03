//
//  RegisterViewController.swift
//  Emoji Challenge
//
//  Created by Anthony Mercado on 4/25/19.
//  Copyright © 2019 COSC 3326. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func btnRegisterTapped(_ sender: UIButton) {
        
        // TODO: Form Validation
        if let email = emailTextField.text, let pass = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                if user != nil {
                    // User if found go to home page
                    print("\nUser created\n")
                    self.performSegue(withIdentifier: "goToHomeFromRegister", sender: self)
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.usernameTextField.text
                    changeRequest?.commitChanges(completion: { (error) in
                        if error != nil {
                            print("User display name changed!")
                        }
                    })
                    
                }
                else {
                    // Error: check error and show message
                    print("Error creating user: \(error!.localizedDescription)")
                }
            }
        } // ends if let
    }

}
