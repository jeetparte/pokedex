//
//  Constants.swift
//  pokedex
//
//  Created by Jeet Parte on 21/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import Foundation

typealias downloadComplete = () -> ()
let POKEAPI_BASE_URL: String = "http://pokeapi.co/api/v2/pokemon/"
let POKEAPI_V1_BASE_URL: String = POKEAPI_BASE_URL.replacingOccurrences(of: "v2", with: "v1")
