//
//  PokeCell.swift
//  pokedex
//
//  Created by Jeet Parte on 16/06/17.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func configureCell(from pokemon: Pokemon) {
        thumbnail.image = UIImage(named: "\(pokemon.pokedexID)")
        nameLabel.text = pokemon.name.capitalized
    }
}
