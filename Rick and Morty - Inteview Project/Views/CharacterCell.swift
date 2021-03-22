//
//  CharacterCell.swift
//  Rick and Morty - Inteview Project
//
//  Created by Denis Onofras on 22.03.2021.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        cardView.layer.shadowRadius = 5.0
        cardView.layer.shadowOpacity = 0.75
        
        characterImage.layer.cornerRadius = 10
        characterImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
