//
//  Pokemon.swift
//  pokedex
//
//  Created by Jeet Parte on 16/06/17.
//

import Foundation
import Alamofire
class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    private var _type: String!
    private var _speed: Int!
    private var _attack: Int!
    private var _defense: Int!
    private var _special_attack: Int!
    private var _special_defense: Int!
    private var _hp: Int!
    private var _description: String!
    private var _nextEvolution: String!
    private var _nextEvolutionID: Int!
    
    var name: String {
        return _name == nil ? "" : _name
    }
    
    var pokedexID: Int {
        return _pokedexID == nil ? -1 : _pokedexID
    }
    
    var type: String {
        return _type == nil ? "" : _type
    }
    
    var speed: Int {
        return _speed == nil ? 0: _speed
    }
    
    var attack: Int {
        return _attack == nil ? 0: _attack
    }
    
    var defense: Int {
        return _defense == nil ? 0: _defense
    }
    
    var special_attack: Int {
        return _special_attack == nil ? 0: _special_attack
    }
    
    var special_defense: Int {
        return _special_defense == nil ? 0: _special_defense
    }
    
    var hp: Int {
        return _hp == nil ? 0: _hp
    }
    
    var description: String {
        return _description == nil ? "" : _description
    }
    
    var nextEvolution: String {
        return _nextEvolution == nil ? "" : _nextEvolution
    }
    
    var nextEvolutionID: Int {
        return _nextEvolutionID == nil ? 0 : _nextEvolutionID
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        _speed = 0
        _attack = 0
        _defense = 0
        _special_attack = 0
        _special_defense = 0
        _hp = 0
        _description = ""
        _nextEvolution = ""
        _nextEvolutionID = 0
    }
    
    convenience init(pokemonDict: Dictionary<String, AnyObject>, completion: @escaping downloadComplete) {
        
        self.init(name: "", pokedexID: 0)
        
        //Download description from API
        if let speciesDict = pokemonDict["species"] as? Dictionary<String, AnyObject> {
            if let speciesURL = speciesDict["url"] as? String {
                Alamofire.request(speciesURL).responseJSON { response in
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        if let flavorTextEntries = dict["flavor_text_entries"] as? [Dictionary<String, AnyObject>] {
                            let desiredEntry =  flavorTextEntries[1]
                            let pokemonDescription: String = desiredEntry["flavor_text"]! as! String
                            self._description = pokemonDescription
                        }
                    }
                    completion()
                }
            }
        }
        
        //Set name and pokedexID
        if let name = pokemonDict["name"] as? String {
            self._name = name.capitalized
        }
        
        if let pokedexID = pokemonDict["id"] as? Int {
            self._pokedexID = pokedexID
        }
        //Set type
        if let types = pokemonDict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
            let primaryType = types[0]
            let primaryTypeName = primaryType["type"]?["name"] as! String
            self._type = primaryTypeName.capitalized
            
            if types.count > 1 { //there are more than one types
                for x in 1..<types.count {
                    let type = types[x]
                    let typeName = type["type"]?["name"] as! String
                    self._type! += " / " + typeName.capitalized
                    
                }
            }
        }
        
        //Setting stats
        if let stats = pokemonDict["stats"] as? [Dictionary<String, AnyObject>] {
            for dict in stats {
                if let stat = dict["stat"] as? Dictionary<String, AnyObject> {
                    let statType: String = stat["name"]! as! String
                    let statValue: Int = dict["base_stat"]! as! Int
                    
                    switch statType {
                    case "speed":
                        self._speed = statValue
                    case "attack":
                        self._attack = statValue
                    case "defense":
                        self._defense = statValue
                    case "special-attack":
                        self._special_attack = statValue
                    case "special-defense":
                        self._special_defense = statValue
                    case "hp":
                        self._hp = statValue
                    default:
                        break
                    }
                }
            }
        }
        
        //Setting next evolution ID
        let pokemonID = "\(self._pokedexID!)/"
        let pokeapi_url = POKEAPI_V1_BASE_URL + pokemonID
        Alamofire.request(pokeapi_url).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvolution! = nextEvolution
                            
                            if let nextEvolutionURI = evolutions[0]["resource_uri"] as? String {
                                let nextEvolutionID = nextEvolutionURI.replacingOccurrences(of: "/api/v1/pokemon/", with: "").replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionID! = Int(nextEvolutionID)!
                            }
                        }
                    }
                }
            }
            completion()
        }
    }
}
