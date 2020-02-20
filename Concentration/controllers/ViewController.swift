//
//  ViewController.swift
//  Concentration
//

import UIKit

class ViewController: UIViewController {
    
    // Swift all vars have to be fully initialized before can access any of its properties, lazy keyword allows to bypass this until the var is used
    private lazy var game = Concentration(numberOfCards: cardButtons.count)
    private var themes = [Theme]()
    private var theme: Theme!
    private var emoji = [Card:String]() // dictionary
    private var unusedEmojis: String!
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var matchesLabel: UILabel!
    @IBOutlet private weak var gameCompleteLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            game.chooseCard(at: index)
    
            updateViewFromModel()
        } else {
            print("card not in array")
        }
    }
    
    @IBAction private func touchNewGameButton(_ sender: UIButton) {
        if game.isComplete {
            setTheme()
            game = Concentration(numberOfCards: cardButtons.count)
    
            updateViewFromModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for button in cardButtons {
            button.layer.cornerRadius = 5
//            button.clipsToBounds = true
        }
        newGameButton.layer.cornerRadius = 5
//        newGameButton.clipsToBounds = true
        setTheme()
    }
    
    private func setTheme() {
        themes.append(
            Theme(
                name: "Halloween",
                primaryColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),
                secondaryColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                emojiChoices: "🦇😱🙀😈🎃👻🍭🍬🍎"
            )
        )
        theme = themes[themes.count.arc4random]
        self.view.backgroundColor = theme.secondaryColor
        matchesLabel.textColor = theme.primaryColor
        gameCompleteLabel.textColor = theme.primaryColor
        newGameButton.backgroundColor = theme.primaryColor
        newGameButton.setTitleColor(theme.secondaryColor, for: UIControl.State.normal)
        unusedEmojis = theme.emojiChoices
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Matches: \(game.matches)", attributes: attributes)
        matchesLabel.attributedText = attributedString
        if game.isComplete {
            gameCompleteLabel.text = "Completed in \(game.flips) flips"
            newGameButton.backgroundColor = theme.primaryColor
            newGameButton.setTitle("New Game", for: UIControl.State.normal)
        } else {
            gameCompleteLabel.text = ""
            newGameButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            newGameButton.setTitle("", for: UIControl.State.normal)
        }
        
        for index in cardButtons.indices {
            let card = game.cards[index]
            let button = cardButtons[index]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.setTitle(toEmoji(for: card), for: UIControl.State.normal)
            } else if card.isMatched {
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
                button.setTitle("", for: UIControl.State.normal)
            } else {
                button.backgroundColor = theme.primaryColor
                button.setTitle("", for: UIControl.State.normal)
            }
        }
    }
    
    private func toEmoji(for card: Card) -> String {
        if emoji[card] == nil {
            let randomStringIndex = unusedEmojis.index(unusedEmojis.startIndex, offsetBy: unusedEmojis.count.arc4random)
            emoji[card] = String(unusedEmojis.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }

}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

