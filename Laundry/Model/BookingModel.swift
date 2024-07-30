//
//  BookingModel.swift
//  RTicket
//
//  Created by Pavankumar Arepu on 28/07/24.
//

import Foundation
import SwiftUI
import RealmSwift

class BookingModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var bookedBy = ""
    @Persisted var date = Date()
    @Persisted var timeSlot = ""
    @Persisted var status = BookingStatus.notStarted
    
    convenience init(bookedBy: String, date: Date, timeSlot: String) {
        self.init()
        self.bookedBy = bookedBy
        self.date = date
        self.timeSlot = timeSlot
    }
}

enum BookingStatus: String, PersistableEnum {
    case notStarted
    case inProgress
    case complete
}
