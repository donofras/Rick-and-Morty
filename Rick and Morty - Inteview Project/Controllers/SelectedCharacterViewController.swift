//
//  SelectedCharacterViewController.swift
//  Rick and Morty - Inteview Project
//
//  Created by Denis Onofras on 22.03.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class SelectedCharacterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fisrtSeenLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var alsofromLabel: UILabel!
    
    var selectedCharacter : Character?
    
    var charactersInEpisode = [Character]()
    
    var webService = Webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        webService.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil) , forCellReuseIdentifier: K.cellIdentifier)
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let character = selectedCharacter {
            
            self.navigationItem.title = character.name
            
            let imageURL = URL(string: character.image)
            imageView.sd_setImage(with: imageURL)
            
            let urlString = character.episode[0]
            AF.request(urlString,method: .get).responseJSON { (response) in
                if let data = response.data {
                    let jsonData : JSON = JSON(data)
                    let episodeName = jsonData["name"].stringValue
                    let characters: [String] = jsonData["characters"].arrayValue.map { $0.stringValue}
                    self.webService.getAllCharactersFromEpisode(characters)
                    self.fisrtSeenLabel.text = episodeName
                    self.alsofromLabel.text = "Also from \"\(episodeName)\""
                }
            }
            locationLabel.text = character.location.name
            statusLabel.text = character.status
        }
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension SelectedCharacterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersInEpisode.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CharacterCell
        
        let imageURL = URL(string: charactersInEpisode[indexPath.row].image)
        cell.characterImage?.sd_setImage(with: imageURL)
        cell.characterLabel.text = charactersInEpisode[indexPath.row].name
        cell.locationLabel.text = charactersInEpisode[indexPath.row].location.name
        
        let urlString = charactersInEpisode[indexPath.row].episode[0]
        AF.request(urlString,method: .get).responseJSON { (response) in
            if let data = response.data {
                let jsonData : JSON = JSON(data)
                cell.episodeLabel.text = jsonData["name"].stringValue
            }
        }
        
        return cell
    }
}

extension SelectedCharacterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
        let character = self.charactersInEpisode[indexPath.row]
        
        self.navigationItem.title = character.name
        
        let imageURL = URL(string: character.image)
        self.imageView.sd_setImage(with: imageURL)
        
        let urlString = character.episode[0]
        AF.request(urlString,method: .get).responseJSON { (response) in
            if let data = response.data {
                let jsonData : JSON = JSON(data)
                let episodeName = jsonData["name"].stringValue
                let characters: [String] = jsonData["characters"].arrayValue.map { $0.stringValue}
                self.webService.getAllCharactersFromEpisode(characters)
                self.fisrtSeenLabel.text = episodeName
                self.alsofromLabel.text = "Also from \"\(episodeName)\""
            }
        }
        self.locationLabel.text = character.location.name
        self.statusLabel.text = character.status
    }
}

extension SelectedCharacterViewController: WebservicesDelegate {
    
    func didUpdateData(_ coinManager: Webservices, characters: [Character]) {
        charactersInEpisode = characters
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}
