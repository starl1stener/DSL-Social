//
//  SignInVC.swift
//  Nag Social
//
//  Created by nag on 12/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("===NAG=== Unable to authenticate with Firebase \(error?.localizedDescription)")

            } else {
                print("===NAG=== Successfully authenticated with Firebase")

            }
        })
    }
    
    
    
    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) {
            (result, error) in
            
            if error != nil {
                print("===NAG=== Unable to authenticate with Facebook \(error?.localizedDescription)")
            } else if result?.isCancelled == true {
                print("===NAG=== User cancelled FB authentication")

            } else {
                print("===NAG=== Successfully authenticated with FB")
                
                print("FBSDKAccessToken.current() = \(FBSDKAccessToken.current())")

                print("FBSDKAccessToken.current().tokenString = \(FBSDKAccessToken.current().tokenString)")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
            
        }
        
        
        
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    print("===NAG=== Existing email authenticated with Firebase")
                } else {
                    
                    print("===NAG=== Existing email auth failed with Firebase")
                    print("===NAG=== \(error?.localizedDescription)")

                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            print("===NAG=== Unable to create email user with Firebase")
                            print("===NAG=== \(error?.localizedDescription)")

                        } else {
                            print("===NAG=== Successfully create and authenticate email user with Firebase")

                        }
                        
                    })
                    
                }
                
            })
            
            
        }
        
        
    }
    
    
}

