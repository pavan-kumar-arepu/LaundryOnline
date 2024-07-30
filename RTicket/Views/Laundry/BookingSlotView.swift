//
//  BookingSlotView.swift
//  RTicket
//
//  Created by Pavankumar Arepu on 28/07/24.
//

import Foundation
import SwiftUI
import RealmSwift

struct BookingSlotView: View {
    @ObservedRealmObject var booking: BookingModel

    var body: some View {
        VStack {
            HStack {
                Text(booking.timeSlot)
                    .font(.headline)
                    .foregroundColor(booking.status == .notStarted ? .red : booking.status == .inProgress ? .yellow : .green)
                Spacer()
                DateView(date: booking.date)
                    .font(.caption)
            }
            HStack {
                Text(booking.bookedBy)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if booking.status == .inProgress {
                Button(action: { $booking.status.wrappedValue = .notStarted }) {
                    Label("Not Started", systemImage: "stop.circle.fill")
                }
                .tint(.red)
            }
            if booking.status == .complete {
                Button(action: { $booking.status.wrappedValue = .inProgress }) {
                    Label("In Progress", systemImage: "bolt.circle.fill")
                }
                .tint(.yellow)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if booking.status == .inProgress {
                Button(action: { $booking.status.wrappedValue = .complete }) {
                    Label("Complete", systemImage: "checkmark.circle.fill")
                }
                .tint(.green)
            }
            if booking.status == .notStarted {
                Button(action: { $booking.status.wrappedValue = .inProgress }) {
                    Label("In Progress", systemImage: "bolt.circle.fill")
                }
                .tint(.yellow)
            }
        }
    }
}
