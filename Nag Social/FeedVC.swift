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
    var imageSelected = false
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

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
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    
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
        
        guard let caption = captionField.text, caption != "" else {
            print("===NAG=== caption has to be entered")
            return
        }
        
        guard let image = imageAdd.image, imageSelected == true else {
            print("===NAG=== an image has to be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imageUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.sharedDataService.REF_POST_IMAGES.child(imageUid).put(imageData, metadata: metaData, completion: { (metaData, error) in
                
                if error != nil {
                    print("===NAG=== Unable to upload image to Firebase Storage")
                } else {
                    print("===NAG=== Successfully image uploaded to Firebase Storage")
                    let downloadURL = metaData?.downloadURL()?.absoluteString // URL for use in Firebase DB for post, postImageUrl
                    
                    if let url = downloadURL {
                        
                        self.postToFirebase(imageUrl: url)
                    }
                    
                }
            })
        }
        
    }
    
    func postToFirebase(imageUrl: String) {
        let postData: Dictionary<String, Any> = [
            
            "caption":  captionField.text!,
            "imageUrl": imageUrl,
            "likes":    0
        ]
        
        let firebasePost = DataService.sharedDataService.REF_POSTS.childByAutoId()
        
        firebasePost.setValue(postData)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
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
            
            if let cachedImage = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                postCell.configureCell(post: post, image: cachedImage)
                return postCell
            } else {
                postCell.configureCell(post: post)
                return postCell
            }
            
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
            self.imageSelected = true
        } else {
            print("===NAG=== Valid image wasn't selected")
        }
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
}








