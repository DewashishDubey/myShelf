//
//  WishlistManager.swift
//  myShelf
//
//  Created by Dewashish Dubey on 26/04/24.
//

import Foundation
import Firebase
func addToWishlist(bookUID: String, forUserUID userUID: String) {
    let db = Firestore.firestore()
    
    let userRef = db.collection("members").document(userUID)
    let wishlistRef = userRef.collection("wishlist")
    
    // Add the book to the wishlist
    wishlistRef.document(bookUID).setData(["bookUID": bookUID]) { error in
        if let error = error {
            print("Error adding document to wishlist: \(error)")
        } else {
            print("Document added to wishlist")
        }
    }
}

// Function to remove a book from the wishlist
func removeFromWishlist(bookUID: String, forUserUID userUID: String) {
    let db = Firestore.firestore()
    
    let userRef = db.collection("members").document(userUID)
    let wishlistRef = userRef.collection("wishlist")
    
    // Remove the book from the wishlist
    wishlistRef.document(bookUID).delete { error in
        if let error = error {
            print("Error removing document from wishlist: \(error)")
        } else {
            print("Document removed from wishlist")
        }
    }
}

func isBookInWishlist(bookUID: String, forUserUID userUID: String, completion: @escaping (Bool) -> Void) {
    let db = Firestore.firestore()
    
    let userRef = db.collection("members").document(userUID)
    let wishlistRef = userRef.collection("wishlist")
    
    // Check if the document exists in the wishlist
    wishlistRef.document(bookUID).getDocument { (document, error) in
        if let document = document, document.exists {
            // Book is in the wishlist
            completion(true)
        } else {
            // Book is not in the wishlist
            completion(false)
        }
    }
}
