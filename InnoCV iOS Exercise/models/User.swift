//
//  models.swift
//  InnoCV iOS Exercise
//
//  Created by Pablo Figueroa Martínez on 12/5/21.
//

import Foundation

/// User model
struct User: Encodable, Decodable, Identifiable {
    let id: Int?
    var name: String? = "Name is not available"
    var birthdate: String? = "Birthdate is not available"
}
