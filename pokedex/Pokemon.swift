//
//  Pokemon.swift
//  pokedex
//
//  Created by Jeet Parte on 16/06/17.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    
    var name: String {
        return _name == nil ? "" : _name
    }
    
    var pokedexID: Int {
        return _pokedexID == nil ? -1 : _pokedexID
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
    }
}
