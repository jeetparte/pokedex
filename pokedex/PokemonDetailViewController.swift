//
//  PokemonDetailViewController.swift
//  pokedex
//
//  Created by Jeet Parte on 20/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    var pokemon: Pokemon!
    
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update properties using pokemon
        pokemonNameLabel.text = pokemon.name.capitalized
        
}
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
