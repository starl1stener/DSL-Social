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
    
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("===NAG=== WE ARE IN FEED VC")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        DataService.sharedDataService.REF_POSTS.observe(.value, with: { snapshot in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
//                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? [String: AnyObject] {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.posts.append(post)
                        
                    }
                }
            }
            self.tableView.reloadData()
        
        })
        
    }
    
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
        
        
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



extension FeedVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.row]
        
        print("===NAG=== post.caption = \(post.caption)")
        
        if let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            postCell.configureCell(post: post)
            return postCell
        } else {
            return PostCell()
        }
        
        
    }
    
}

extension FeedVC: UITableViewDelegate {
    
}

extension FeedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageAdd.image = image
        } else {
            print("===NAG=== Valid image wasn't selected")
        }
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
}








