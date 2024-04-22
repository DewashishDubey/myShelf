//
//  myShelfApp.swift
//  myShelf
//
//  Created by Dewashish Dubey on 22/04/24.
//

import SwiftUI
import Firebase
@main
struct myShelfApp: App {
    init()
    {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())
        }
    }
}
