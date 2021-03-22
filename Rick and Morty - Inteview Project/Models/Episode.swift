//
//  Episode.swift
//  Rick and Morty - Inteview Project
//
//  Created by Denis Onofras on 22.03.2021.
//

import Foundation

struct EpisodeResponse: Codable {
    let info: Info
    let results: [Episode]
}

struct Episode: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
    
    func characterIds() -> String {
        var ids = ""
        for characterUrl in characters {
            if let index = characterUrl.range(of: "character/")?.upperBound {
                let characterIdSubString = (characterUrl[index...])
                let characterId = String(characterIdSubString)
                ids.append(characterId + ",")
            }
        }
        return ids
    }
}
