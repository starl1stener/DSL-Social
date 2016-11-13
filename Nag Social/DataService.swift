//
//  DataService.swift
//  Nag Social
//
//  Created by nag on 13/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let sharedDataService = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    
    func createFirebaseDBUser(uid: String, userData: [String: String]) {
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
    
}


















