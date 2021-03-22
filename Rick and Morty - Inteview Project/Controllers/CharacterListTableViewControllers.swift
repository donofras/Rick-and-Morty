//
//  CharacterListTableViewControllers.swift
//  Rick and Morty - Inteview Project
//
//  Created by Denis Onofras on 22.03.2021.
//

import Foundation
import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON

class CharacterListTableViewControllers: UITableViewController {

    var characterList = [Character]()
    var webService = Webservices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webService.delegate = self
        webService.getAllCharacters()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil) , forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CharacterCell
        
        let imageURL = URL(string: characterList[indexPath.row].image)
        cell.characterImage?.sd_setImage(with: imageURL)
        cell.characterLabel.text = characterList[indexPath.row].name
        cell.locationLabel.text = characterList[indexPath.row].location.name
        
        
        let urlString = characterList[indexPath.row].episode[0]
        AF.request(urlString,method: .get).responseJSON { (response) in
            if let data = response.data {
                let jsonData : JSON = JSON(data)
                cell.episodeLabel.text = jsonData["name"].stringValue
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        self.performSegue(withIdentifier: "slectedCharacterSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SelectedCharacterViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCharacter = characterList[indexPath.row]
        }
    }
}


extension CharacterListTableViewControllers: WebservicesDelegate {
    
    func didUpdateData(_ coinManager: Webservices, characters: [Character]) {
        characterList = characters
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}


