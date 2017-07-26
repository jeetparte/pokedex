//
//  PokemonDetailViewController.swift
//  pokedex
//
//  Created by Jeet Parte on 20/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailViewController: UIViewController {
    
    weak var pokemon: Pokemon!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    @IBOutlet weak var pokemonDescriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //update properties using pokemon
        pokemonNameLabel.text = pokemon.name.capitalized
        if let pokemonImage = UIImage(named: "\(pokemon.pokedexID)") {
            self.pokemonImage.image = pokemonImage
            self.currentEvolutionImage.image = pokemonImage
        }
        self.downloadPokemonDetails {
            self.updateUI()
        }
    }
    
    func downloadPokemonDetails(completion: @escaping downloadComplete) {
        let pokemonID = "\(pokemon.pokedexID)/"
        let pokeapi_url = POKEAPI_BASE_URL + pokemonID
        Alamofire.request(pokeapi_url).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                self.pokemon = Pokemon(pokemonDict: dict, completion: {
                    self.pokemonDescriptionLabel.text = self.pokemon.description
                    self.nextEvolutionImage.image = UIImage(named: "\(self.pokemon.nextEvolutionID)")
                })
            }
            completion()
        }
    }
    
    func updateUI() {
        typeLabel.text = pokemon.type
        speedLabel.text = "\(pokemon.speed)"
        hpLabel.text = "\(pokemon.hp)"
        defenseLabel.text = "\(pokemon.defense)"
        specialDefenseLabel.text = "\(pokemon.special_defense)"
        attackLabel.text = "\(pokemon.attack)"
        specialAttackLabel.text = "\(pokemon.special_attack)"
        pokemonDescriptionLabel.text = pokemon.description
    }
}

//MARK: - IBActions
extension PokemonDetailViewController {
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
