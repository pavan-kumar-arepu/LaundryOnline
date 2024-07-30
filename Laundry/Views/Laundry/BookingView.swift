//
//  BookingView.swift
//  RTicket
//
//  Created by Pavankumar Arepu on 28/07/24.
//

import Foundation
import SwiftUI
import RealmSwift

struct BookingView: View {
    let username: String
    var isPreview = false

    @ObservedResults(BookingModel.self, sortDescriptor: SortDescriptor(keyPath: "status", ascending: false)) var bookings
    @Environment(\.realm) var realm

    @State private var selectedDate = Date()
    @State private var selectedTimeSlot = ""
    @State private var searchText = ""
    @State private var inProgress = false
    private let timeSlots = ["7 - 10 AM", "10 - 1 PM", "1 - 4 PM", "4 - 7 PM", "7 - 10 PM"]

    var body: some View {
        let filteredBookings = bookings.where {
            $0.date == selectedDate && $0.timeSlot == selectedTimeSlot
        }
        
        // Print bookings for debugging
        print("All bookings: \(bookings)")
        print("Filtered bookings: \(filteredBookings)")

        return ZStack {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .padding()
                Picker("Select Time Slot", selection: $selectedTimeSlot) {
                    ForEach(timeSlots, id: \.self) { slot in
                        Text(slot).tag(slot)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(filteredBookings) { booking in
                        BookingSlotView(booking: booking)
                    }
                }
                .searchable(text: $searchText)
                Spacer()
                VStack {
                    Button(action: addBooking) {
                        Text("Add Booking")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedTimeSlot.isEmpty)
                }
                .padding()
            }
            if inProgress {
                ProgressView()
            }
        }
        .navigationBarTitle("Laundry Bookings", displayMode: .inline)
        .onAppear(perform: setSubscriptions)
        .onDisappear(perform: clearSubscriptions)
    }

    private func setSubscriptions() {
        if !isPreview {
            let subscriptions = realm.subscriptions
            if subscriptions.first(named: "bookings") == nil {
                inProgress = true
                subscriptions.update() {
                    subscriptions.append(QuerySubscription<BookingModel>(name: "bookings") { booking in
                        booking.status != .complete
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
                subscriptions.remove(named: "bookings")
            } onComplete: { error in
                if let error = error {
                    print("Failed to unsubscribe for bookings: \(error.localizedDescription)")
                }
            }
        }
    }

    private func addBooking() {
        let booking = BookingModel(bookedBy: username, date: selectedDate, timeSlot: selectedTimeSlot)
        $bookings.append(booking)
        selectedTimeSlot = ""
        
        // Print for debugging
        print("Added booking: \(booking)")
    }
}
