//
//  LoginViewController.swift
//  Emoji Challenge
//
//  Created by Anthony Mercado on 4/24/19.
//  Copyright © 2019 COSC 3326. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Login Button Outlet and loginButtonTapped Action
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        // TODO: Form Validation
        if let email = emailTextField.text, let pass = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
                else {
                    // Error: check error and show message
                }
            }
        }
    }
    
    // Register Button and registerButtonTapped Action
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    // username and password textfields for login
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder
        passwordTextField.resignFirstResponder()
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print("handle user signup / login")
    }
}
