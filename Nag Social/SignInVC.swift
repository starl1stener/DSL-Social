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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
            print("===NAG=== GOING TO FEED VC")
        }
    }
    
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("===NAG=== Unable to authenticate with Firebase \(error!.localizedDescription)")

            } else {
                print("===NAG=== Successfully authenticated with Firebase")
                
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignInWith(id: user.uid, userData: userData)
                }
                
            }
        })
    }
    
    func completeSignInWith(id: String, userData: [String: String]) {
        
        DataService.sharedDataService.createFirebaseDBUser(uid: id, userData: userData)
        
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("===NAG=== Saved to keychain")
        performSegue(withIdentifier: "goToFeed", sender: nil)


    }
    
    
    
    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) {
            (result, error) in
            
            if error != nil {
                print("===NAG=== Unable to authenticate with Facebook \(error!.localizedDescription)")
            } else if result?.isCancelled == true {
                print("===NAG=== User cancelled FB authentication")

            } else {
                print("===NAG=== Successfully authenticated with FB")
                
                print("FBSDKAccessToken.current() = \(FBSDKAccessToken.current())")

                print("FBSDKAccessToken.current().tokenString = \(FBSDKAccessToken.current().tokenString)")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    print("===NAG=== Existing email authenticated with Firebase")
                    
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignInWith(id: user.uid, userData: userData)
                        
                    }

                } else {
                    
                    print("===NAG=== Existing email auth failed with Firebase")
                    print("===NAG=== \(error?.localizedDescription)")

                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            print("===NAG=== Unable to create email user with Firebase")
                            print("===NAG=== \(error?.localizedDescription)")

                        } else {
                            print("===NAG=== Successfully create and authenticate email user with Firebase")
                            
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignInWith(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
}

