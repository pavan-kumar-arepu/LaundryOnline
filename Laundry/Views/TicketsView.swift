//
//  TicketsView.swift
//  RTicket
//
//  Created by Andrew Morgan on 25/02/2022.
//

import SwiftUI
import RealmSwift

struct TicketsView: View {
    let product: String
    let username: String
    let lastYear = Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate.rounded() - (60 * 60 * 24 * 365))
    var isPreview = false
    
    @ObservedResults(TicketModel.self, sortDescriptor: SortDescriptor(keyPath: "status", ascending: false)) var tickets
    @Environment(\.realm) var realm
    
    @State private var title = ""
    @State private var description = ""
    @State private var searchText = ""
    @State private var inProgress = false
    
    var body: some View {
        let filteredTickets = tickets.where {
            $0.title.contains(searchText, options: .caseInsensitive) ||
            $0.problemDescription.contains(searchText, options: .caseInsensitive)
        }
        return ZStack {
            VStack {
                List {
                    ForEach(searchText == "" ? tickets : filteredTickets) { ticket in
                        TicketView(ticket: ticket)
                    }
                }
                .searchable(text: $searchText)
                Spacer()
                VStack {
                    TextField("Ticket title", text: $title)
                    TextField("Ticket description", text: $description)
                        .font(.caption)
                    Button(action: addTicket) {
                        Text("Add Ticket")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(title == "")
                }
                .padding()
            }
            if inProgress {
                ProgressView()
            }
            
        }
        .navigationBarTitle("\(product) Tickets", displayMode: .inline)
        .onAppear(perform: setSubscriptions)
        .onDisappear(perform: clearSubscriptions)
    }
    
    private func setSubscriptions() {
        if !isPreview {
            let subscriptions = realm.subscriptions
            if subscriptions.first(named: product) == nil {
                inProgress = true
                subscriptions.update() {
                subscriptions.append(QuerySubscription<TicketModel>(name: product) { ticket in
                    ticket.product == product &&
                    (
                        ticket.status != .complete || ticket.created > lastYear
                    )
                })
                } onComplete: { _ in
                    Task { @MainActor in
                        inProgress = false
                    }
                }
            }
        }
    }
    
    private func clearSubscriptions() {
        if !isPreview {
            let subscriptions = realm.subscriptions
            subscriptions.update {
                subscriptions.remove(named: product)
            } onComplete: { error in
                if let error = error {
                    print("Failed to unsubscribe for \(product): \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func addTicket() {
        let ticket = TicketModel(reportedBy: username, product: product, title: title, problemDescription: description != "" ? description : nil)
        $tickets.append(ticket)
        title = ""
        description = ""
    }
}

//struct TicketsView_Previews: PreviewProvider {
//    static var previews: some View {
//        if !TicketModel.areTicketsPopulated {
//            TicketModel.bootstrapTickets()
//        }
//        return NavigationView {
//            TicketsView(product: "Realm", username: "Andrew", isPreview: true)
//        }
//    }
//}
