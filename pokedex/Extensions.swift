//
//  Extensions.swift
//  pokedex
//
//  Created by Jeet Parte on 01/07/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//
import Foundation
extension String {
    func removeWhitespacesAndNewlines() -> String {
        return self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter{ !$0.isEmpty }.joined(separator: " ")
        
    }
}
