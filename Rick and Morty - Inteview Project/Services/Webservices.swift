//
//  Webservices.swift
//  Rick and Morty - Inteview Project
//
//  Created by Denis Onofras on 22.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol WebservicesDelegate {
    func didUpdateData(_ coinManager: Webservices, characters: [Character])
    func didFailWithError(error: Error)
}

class Webservices {
    
    var delegate: WebservicesDelegate?
    
    let baseURL = "https://rickandmortyapi.com/api"
    
    func getAllCharacters() {
        let urlString = "\(baseURL)/character"
        
        AF.request(urlString, method: .get).responseJSON { (response) in
            if let data = response.data {
                self.parseJSON(data)
            }
        }
    }
    
    func getAllCharactersFromEpisode(_ characterURLS: [String]) {
        var characterList = [Character]()
        
        for urlString in characterURLS {
            AF.request(urlString, method: .get).responseJSON { (response) in
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(Character.self, from: data)
                        characterList.append(decodedData)
                        self.delegate?.didUpdateData(self, characters: characterList)
                    } catch {
                        self.delegate?.didFailWithError(error: error)
                    }
                }
            }
        }
        
        //self.delegate?.didUpdateData(self, characters: characterList)
    }
    
    func parseJSON(_ characterResult: Data)  {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CharacterResponse.self, from: characterResult)
            let characterList = decodedData.results
            self.delegate?.didUpdateData(self, characters: characterList)
        } catch {
            self.delegate?.didFailWithError(error: error)
        }
    }
    
}
