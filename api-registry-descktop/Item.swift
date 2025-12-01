//
//  Item.swift
//  api-registry-descktop
//
//  Created by seregin-ma on 01.12.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
