//
//  Card.swift
//  Concentration
//

import Foundation

struct Card {
    var isMatched = false
    var isFaceUp = false
    let type: Int
    
    private static var typeFactory = 0
    
    private static func getUniqueType() -> Int {
        typeFactory += 1
        return typeFactory
    }
    
    init() {
        type = Card.getUniqueType()
    }
}
