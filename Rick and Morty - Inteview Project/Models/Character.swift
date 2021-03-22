//
//  Character.swift
//  Rick and Morty - Inteview Project
//
//  Created by Denis Onofras on 22.03.2021.
//

import Foundation

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct CharacterLocation: Codable {
    let name: String
    let url: String
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
