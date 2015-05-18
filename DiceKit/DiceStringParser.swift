//
//  DiceStringParser.swift
//  Dragon Dice
//
//  Created by Mims Wright on 5/13/15.
//  Copyright (c) 2015 Mims Wright. All rights reserved.
//

import Foundation

public class DiceStringParser {
    
    public func parseDiceString (originalDiceString:String) -> DiceCollection {
        var diceString:String
        var range:NSRange
        var error:NSError? = nil
        let dice = DiceCollection()
        
        if (originalDiceString.isEmpty) {
            return dice
        }
        
        
        range = NSMakeRange(0, count(originalDiceString))

        // ignore whitespaces
        let whitespace:NSRegularExpression = NSRegularExpression(pattern: "\\s*", options: NSRegularExpressionOptions(0), error: &error)!
        
        diceString = whitespace.stringByReplacingMatchesInString (originalDiceString,
            options: NSMatchingOptions(0),
            range: range,
            withTemplate: ""
        )
        diceString = diceString.lowercaseString;
        
        
        range = NSMakeRange(0, count(diceString))
        
        let digits:NSRegularExpression = NSRegularExpression(pattern: "[0-9]", options: NSRegularExpressionOptions(0), error: &error)!
    
//        let ops:NSRegularExpression = NSRegularExpression(pattern: "-|+", options: NSRegularExpressionOptions(0), error: &error)!

        let diceSeperator = "d"
        
        let chars = Array(diceString)
        range = NSMakeRange(0, 1)
        
        
        
        return dice
    }
}