//
//  Concentration.swift
//  Concentration
//

import Foundation

struct Concentration {

    private var indexOfOnlyUpCard: Int?

    private(set) var cards = [Card]()
    private(set) var matches = 0
    private(set) var flips = 0
    
    var isComplete: Bool {
        get {
            for card in cards {
                if !card.isMatched { return false }
            }
            return true
        }
    }
    
    init(numberOfCards: Int) {
        assert(numberOfCards > 0 && numberOfCards % 2 == 0, "bad numberOfCards")
        let numberOfCardPairs = numberOfCards / 2
        for _ in 1...numberOfCardPairs {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    // when Concentration was changed from class to struct, had to update `func chooseCard()` to `mutating func chooseCard()`
    // modifying cards, matches, flips, etc. properties of this struct is mutating the struct
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "card out of index")
        // if already matched, do nothing
        if !cards[index].isMatched {
            // flip card
            cards[index].isFaceUp = true

            // unwrap indexOfOnlyUpCard and check if index != matchIndex
            if let matchIndex = indexOfOnlyUpCard, index != matchIndex {
                // only one card was up, and it wasn't selected again
                if cards[matchIndex] == cards[index] {
                    // match found
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    matches += 1
                }
                indexOfOnlyUpCard = nil
            } else {
                // indexOfOnlyUpCard is nil
                // either no cards or two cards up
                // flip all cards down, and flip selected card back up
                for i in cards.indices {
                    cards[i].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOnlyUpCard = index
            }
            flips += 1
        }
    }

}
