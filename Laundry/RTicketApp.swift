//
//  RTicketApp.swift
//  RTicket
//
//  Created by Andrew Morgan on 25/02/2022.
//

import SwiftUI
import RealmSwift

let realmApp = RealmSwift.App(id: "fdsfds") // TODO: Copy the app id from the backend Realm app
let useEmailPasswordAuth = true // TODO: set to "true" if you want to user username/password rather than anonymous authentication

@main
struct RTicketApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
