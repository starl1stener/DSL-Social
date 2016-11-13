//
//  FeedVC.swift
//  Nag Social
//
//  Created by Anton Novoselov on 13/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("===NAG=== WE ARE IN FEED VC")
    }
    
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        
    }
    
    @IBAction func postBtnTapped(_ sender: AnyObject) {
        
    }
    
    
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("===NAG=== Logout")

        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }


    
}
