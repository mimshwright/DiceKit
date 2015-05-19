//
//  DiceStringParser.swift
//  Dragon Dice
//
//  Created by Mims Wright on 5/13/15.
//  Copyright (c) 2015 Mims Wright. All rights reserved.
//

import Foundation

public class DiceStringParser {
    
    public static func parseDiceString (originalDiceString:String) -> DiceCollection? {
        if (originalDiceString.isEmpty) {
            return DiceCollection()
        }
        
        var diceString = originalDiceString.lowercaseString
        
        if (validateDiceString(diceString) == false) {
            return nil
        }
        
        diceString = replaceMinusWithPlusMinus (diceString)
        
        var dice:DiceCollection? = DiceCollection()
        
        let segments = split(diceString) {$0 == "+"}
        for segment in segments {
            parseSegment( segment: segment, diceCollection: &dice)
            
            if (dice == nil) {
                return nil
            }
        }
        
        return dice
    }
    
    private static func validateDiceString (diceString:String) -> Bool {
        let validCharachtersPattern = "[0-9d\\+\\-]"
        let validChars = NSRegularExpression(pattern: validCharachtersPattern, options: NSRegularExpressionOptions(0), error: nil)
        let range = NSMakeRange(0, count(diceString))
        let validMatches = validChars?.matchesInString(diceString, options: NSMatchingOptions(0), range: range) as! [NSTextCheckingResult]
        
        return validMatches.count == count(diceString)
    }
    
    private static func replaceMinusWithPlusMinus (diceString:String) -> String {
        let minusSearch = NSRegularExpression(pattern: "\\-", options: NSRegularExpressionOptions(0), error: nil)
        let range = NSMakeRange(0, count(diceString))
        let replacedDiceString = minusSearch?.stringByReplacingMatchesInString(diceString, options: NSMatchingOptions(0), range: range, withTemplate: "+-")

        return replacedDiceString ?? diceString
    }
    
    private static func parseSegment (#segment:String, inout diceCollection:DiceCollection?) {
        if (diceCollection == nil) {
            return Void()
        }
        
        let nsStringSegment = segment as NSString
        let dicePattern = "^\\d+d\\d+$"
        let diceSearch = NSRegularExpression(pattern: dicePattern, options: NSRegularExpressionOptions(0), error: nil)
        let range = NSMakeRange(0, nsStringSegment.length)
        let diceMatchRanges = diceSearch?.matchesInString(segment, options: NSMatchingOptions(0), range: range) as! [NSTextCheckingResult]
        let diceMatchResults = map(diceMatchRanges) { nsStringSegment.substringWithRange($0.range) }
        let numberOfDiceMatches = diceMatchResults.count
        
        if (numberOfDiceMatches == 0) {
            // try to match digits
            let digitPattern = "^\\-?\\d+$"
            let digitSearch = NSRegularExpression(pattern: digitPattern, options: NSRegularExpressionOptions(0), error: nil)
            let digitMatchRanges = digitSearch?.matchesInString(segment, options: NSMatchingOptions(0), range: range) as! [NSTextCheckingResult]
            let digitMatchResults = map(digitMatchRanges) { nsStringSegment.substringWithRange($0.range) }
            let numberOfDigitMatches = digitMatchResults.count
            
            if (numberOfDigitMatches == 1) {
                //parse digits
                let constant = digitMatchResults[0].toInt() ?? 0
                diceCollection!.constant += constant
            } else {
                // error
                diceCollection = nil
                return Void()
            }

        } else if (numberOfDiceMatches == 1) {
            // string as dice set
            let diceString = diceMatchResults[0]
            let diceComponents = split(diceString) { $0 == "d" }
            
            if (diceComponents.count == 2) {
                let diceCount = UInt(diceComponents[0].toInt() ?? 0)
                let dieFaces = UInt(diceComponents[1].toInt() ?? 1)
                diceCollection!.addDieWithFaces( dieFaces, numberOfTimes: diceCount)
            } else {
                // error
            }
            
        } else {
            // error?
        }
    }
}