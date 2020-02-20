//
//  Card.swift
//  Concentration
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int { return type }
    
    var isMatched = false
    var isFaceUp = false
    
    private let type: Int
    private static var typeFactory = 0
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.type == rhs.type
    }
    
//    static func hash(into hasher: inout Hasher) {
//        hasher.combine(type)
//    }
    
    private static func getUniqueType() -> Int {
        typeFactory += 1
        return typeFactory
    }
    
    init() {
        type = Card.getUniqueType()
    }
}
