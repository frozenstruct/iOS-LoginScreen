//
//  LoginViewController.swift
//  AVSoftTest
//
//  Created by Dmitry Aksyonov on 29.02.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var forgotPasswordButtonOutlet: UIButton!
    @IBOutlet weak var progressViewOutlet: UIProgressView!
    @IBOutlet weak var refreshButtonOutlet: UIButton!
    
    
    // MARK: - Persistent Data
    let persistentDataSingleton = PersistentData.shared
    
    
    // MARK: - Alert Controllers
    let forgotPasswordAlertController = UIAlertController(title: "Oops!", message: "Seems like you have forgotten your password. But there is nothing to restore - no one is registered yet.", preferredStyle: .alert)
    let signUpAlertController = UIAlertController(title: "Invalid Input!", message: "Hey! You left something blank! Insert a valid e-mail and password to sign up.", preferredStyle: .alert)
    let invalidCredentialsAlertController = UIAlertController(title: "Invalid Credentials!", message: "Hey! You entered something bad and we cannot proceed! Please re-enter the login details or hit 'Forgot Password' button to recall the last login details", preferredStyle: .alert)
    
    
    // MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        self.hideKeyboardWhenTappedAround()
        addAlertControllerButtons(for: forgotPasswordAlertController, title: "Do-Whoop")
        addAlertControllerButtons(for: signUpAlertController, title: "Ok, sorry")
        addAlertControllerButtons(for: invalidCredentialsAlertController, title: "Try Again")
        
        eMailTextField.delegate = self
        passwordTextField.delegate = self
        
        eMailTextField.tag = 0
        passwordTextField.tag = 1
        
        progressViewOutlet.setProgress(0, animated: true)
        progressViewOutlet.alpha = 0
    }
    
    // MARK: - Actions
    @IBAction func signInButton(_ sender: Any) {
        
        if eMailTextField.text == persistentDataSingleton.eMail && passwordTextField.text == persistentDataSingleton.password {
            
            progressViewOutlet.setProgress(1, animated: true)
            
            UIView.animate(withDuration: 1, delay: 2, animations: {
                self.progressViewOutlet.alpha = 1
            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 1, animations: {
                self.progressViewOutlet.alpha = 0
            }, completion: nil)
            
            signInButtonOutlet.setTitle("Signed In!", for: .normal)
            signInButtonOutlet.alpha = 0.5
            signInButtonOutlet.isUserInteractionEnabled = false
            
        } else {
            self.present(invalidCredentialsAlertController, animated: true, completion: {
                self.invalidCredentialsAlertController.view.superview?.isUserInteractionEnabled = true
            })
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        if eMailTextField.text != "" && passwordTextField.text != "" {
            persistentDataSingleton.eMail = eMailTextField.text!
            persistentDataSingleton.password = passwordTextField.text!
            
            signUpButtonOutlet.setTitle("Signed Up!", for: .normal)
            signUpButtonOutlet.alpha = 0.5
            signUpButtonOutlet.isUserInteractionEnabled = false
            
            eMailTextField.text = ""
            passwordTextField.text = ""
            
        } else {
            self.present(signUpAlertController, animated: true, completion: {
                self.signUpAlertController.view.superview?.isUserInteractionEnabled = true
            })
        }
    }
    
    @IBAction func rollBackToInitialState(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.refreshButtonOutlet.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.refreshButtonOutlet.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
        }, completion: nil)
        
        signUpButtonOutlet.setTitle("Sign Up", for: .normal)
        signUpButtonOutlet.alpha = 1
        signUpButtonOutlet.isUserInteractionEnabled = true
        
        signInButtonOutlet.setTitle("Sign In", for: .normal)
        signInButtonOutlet.alpha = 1
        signInButtonOutlet.isUserInteractionEnabled = true
        
        progressViewOutlet.setProgress(0, animated: false)
        
        eMailTextField.text = ""
        passwordTextField.text = ""
        
        persistentDataSingleton.eMail.removeAll()
        persistentDataSingleton.password.removeAll()
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        if persistentDataSingleton.eMail == "" && persistentDataSingleton.password == "" {
            self.present(forgotPasswordAlertController, animated: true, completion: {
                self.forgotPasswordAlertController.view.superview?.isUserInteractionEnabled = true
            })
        }
        
        eMailTextField.text = persistentDataSingleton.eMail
        passwordTextField.text = persistentDataSingleton.password
    }
    
    
    // MARK: - Methods
    func prepareTextFields() {
        eMailTextField.layer.cornerRadius = eMailTextField.frame.size.width / 30
        passwordTextField.layer.cornerRadius = passwordTextField.frame.size.width / 30
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: eMailTextField.frame.height))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: passwordTextField.frame.height))
        
        eMailTextField.leftView = paddingView
        eMailTextField.leftViewMode = .always
        
        passwordTextField.leftView = paddingView2
        passwordTextField.leftViewMode = .always
    }
    
    
    func addAlertControllerButtons(for controller: UIAlertController, title: String) {
        controller.addAction(UIAlertAction(title: title, style: .destructive, handler: nil))
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    
    func updateProgressView() {
        if progressViewOutlet.progress != 1 {
            self.progressViewOutlet.progress += 5 / 10
        }
    }
    
    
    @objc func dismissOnTapOutside() {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Extensions
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
