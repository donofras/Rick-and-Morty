//
//  Location.swift
//  Rick and Morty - Inteview Project
//
//  Created by Denis Onofras on 22.03.2021.
//

import Foundation


struct LocationResponse: Codable {
    let info: Info
    let results: [Location]
}

struct Location: Codable {
    let id: Int?
    let name: String
    let type: String?
    let dimension: String?
    let residents: [String]?
    let url: String
    let created: String?
}
