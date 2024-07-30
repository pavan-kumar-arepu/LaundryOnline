//
//  LaundyContentView.swift
//  RTicket
//
//  Created by Pavankumar Arepu on 28/07/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var username: String?
    
    var body: some View {
        NavigationView {
            Group {
                if let username = username {
                    if let currentUser = realmApp.currentUser {
                        BookingView(username: username)
                            .environment(\.realmConfiguration, currentUser.flexibleSyncConfiguration())
                    }
                } else {
                    if useEmailPasswordAuth {
                        EmailLoginView(username: $username)
                    } else {
                        LoginView(username: $username)
                    }
                }
            }
            .navigationBarItems(trailing: username != nil && useEmailPasswordAuth ? LogoutButton(username: $username) : nil)
        }
    }
}
