
//
//  DiceCollection.swift
//  Dragon Dice
//
//  Created by Mims Wright on 5/11/15.
//  Copyright (c) 2015 Mims Wright. All rights reserved.
//

import Foundation
import Swift


public class DiceCollection : Equatable {
    
    // MARK: properties

    /**
        Array holding the dice in this collection.
     */
    public var dice:[Die]
    
    /**
        Derived property for number of dice in the collection.
     */
    public var numberOfDice:Int {
        get {
            return dice.count
        }
    }

    /**
        A constant modifier added or subtracted from the rolled dice.
     */
    public var constant:Int = 0
    
    
    /**
        Gets the maximum possible value for all the dice in the collection plus the constant modifier.
     */
    public var maxValue:Int {
        get {
            var max:Int = constant
            for die in dice {
                max += Int(die.sides)
            }
            return max
        }
    }
    
    /**
    * Gets the minimum possible value for all the dice in the collection including the constant modifier.
    */
    public var minValue:Int {
        get {
            return constant + numberOfDice
        }
    }

    
    // MARK: Initializers
    
    public init() {
        dice = [Die]()
    };
    
    public convenience init?(_ diceString:String) {
        if let convertedString = DiceStringParser.parseDiceString(diceString) {
            self.init(dice: convertedString.dice, constant: convertedString.constant)
        } else {
            self.init()
            return nil
        }
    }
    
    public convenience init(constant:Int) {
        self.init()
        self.constant = constant
    }
    
    public convenience init(dice:[Die], constant:Int = 0) {
        self.init(constant: constant)
        self.dice = dice
    }
    
    public convenience init(dieFaces:UInt, dieCount:UInt = 1, constant:Int = 0) {
        self.init(constant: constant)
        addDieWithFaces (dieFaces, numberOfTimes: dieCount)
    }
    
    //MARK: methods
    
    /**
        Add the die multiple times.
        
        - parameter die: The Die to add.
        - parameter numberOfTimes: The number of times to add the die.
     */
    public func addDie(die:Die, numberOfTimes count:UInt = 1) -> Void {
        for _ in 1...count {
            dice.append(die)
        }
    }
    
    /**
        Alternate add function that creates dice automatically.
        - parameter dieFaces: The number of faces on the die to add.
        - parameter numberOfTimes: The number of times to add the die.
    */
    public func addDieWithFaces(dieFaces:UInt, numberOfTimes count:UInt = 1) -> Void {
        addDie(Die(dieFaces), numberOfTimes: count)
    }
    
    /*
        Roll all dice.
    
        :returns: The results of rolling all dice in the collection including
        the constant modifier.
    */
    public func roll() -> Int {
        var sum:Int = constant;
        for die in dice {
            sum += die.roll()
        }
        return sum
    }
 
    
    /*
        Describes the DiceCollection in a format that is compatible with the 
        DiceStringParser. E.g. "2d6+3" for two six-sieded dice and constant +3
    */
    var description:String {
        get {
            let dice = sortedDice()
            var count = 0
            var string = ""
            
            for i in 0..<dice.count {
                let die = dice[i]
                var nextDie:Die?
                if (i < dice.count-1) {
                    nextDie = dice[i+1]
                } else {
                    nextDie = nil
                }
                
                count += 1
                
                // if nextDie exists and isn't the same as this die or if the next die doesn't exist (this is the last die)
                if (nextDie == nil ||
                    (nextDie != nil && nextDie! != die)) {
                    if (string != "") {
                        string += "+"
                    }
                    
                    string += "\(count)d\(die.sides)"

                    count = 0
                }
            }
            
            // write out constant
            if (string != "" && constant >= 0) {
                string += "+"
            }

            string += "\(constant)"
        
            return string
        }
    }
    
    private func sortedDice () -> [Die] {
        return dice.sort { $0.sides > $1.sides }
    }
}

// MARK: operators


// DiceCollection == DiceCollection
public func == (lhs:DiceCollection, rhs: DiceCollection ) -> Bool {
    return lhs.constant == rhs.constant && lhs.sortedDice() == rhs.sortedDice()
}


// DiceCollection + DiceCollection
public func + (lhs:DiceCollection, rhs:DiceCollection) -> DiceCollection {
    return DiceCollection(dice:(lhs.dice + rhs.dice), constant: (lhs.constant + rhs.constant))
}
public func += (inout lhs:DiceCollection, rhs:DiceCollection) { lhs = lhs + rhs }

// Die + Die
public func + (lhs: Die, rhs: Die) -> DiceCollection {
    return DiceCollection(dice: [lhs, rhs])
}


// DiceCollection + Die
public func + (lhs:DiceCollection, rhs:Die) -> DiceCollection {
    return DiceCollection(dice:lhs.dice + [rhs], constant: lhs.constant)
}
public func + (lhs:Die, rhs:DiceCollection) -> DiceCollection { return rhs + lhs }
public func += (inout lhs:DiceCollection, rhs:Die) { lhs = lhs + rhs }


// DiceCollection +/- Int
public func + (lhs:DiceCollection, rhs:Int) -> DiceCollection {
    lhs.constant += rhs
    return lhs
}
public func + (lhs:Int, rhs:DiceCollection) -> DiceCollection { return rhs + lhs }
public func += (inout lhs:DiceCollection, rhs:Int) { lhs = lhs + rhs }
public func - (lhs:DiceCollection, rhs:Int) -> DiceCollection {
    lhs.constant -= rhs
    return lhs
}



// Die +/- Int
public func + (lhs:Die, rhs:Int) -> DiceCollection {
    return DiceCollection(dice: [lhs], constant: rhs)
}
public func + (lhs:Int, rhs:Die) -> DiceCollection { return rhs + lhs }
public func - (lhs:Die, rhs:Int) -> DiceCollection {
    return DiceCollection(dice: [lhs], constant: -rhs)
}


// Die * Int
public func * (lhs:Die, rhs:UInt) -> DiceCollection {
    return DiceCollection(dieFaces: lhs.sides, dieCount: rhs)
}
public func * (lhs:UInt, rhs:Die) -> DiceCollection { return rhs * lhs }


// MARK: DiceStringParser
private class DiceStringParser {
    
    /*
        Takes a string and returns a dice collection (optional).
        param: originalDiceString, a string to convert in format similar to "2d6+4"
    */
    private static func parseDiceString (originalDiceString:String) -> DiceCollection? {
        if (originalDiceString.isEmpty) {
            return nil
        }
        
        var diceString = originalDiceString.lowercaseString
        
        // make sure the dice string is in a valid format
        if (validateDiceString(diceString) == false) {
            return nil
        }
        
        // for convenience, replace - (minus) character with +-
        diceString = replaceMinusWithPlusMinus (diceString)
        
        var dice:DiceCollection? = DiceCollection()
        
        // split the string into segments using + as the delimiter and convert the segements to strings.
        let segments = split(diceString.characters) {$0 == "+"}.map { String($0) }
        for segment in segments {
            parseSegment( segment: segment, diceCollection: &dice)
            
            if (dice == nil) {
                return nil
            }
        }
        
        return dice
    }
    
    /*
        Checks the string against a list of valid characters. 
        They are: 0123456789d+-
    */
    private static func validateDiceString (diceString:String) -> Bool {
        let range = NSMakeRange(0, diceString.characters.count)
        let validCharsPattern = "[0-9d\\+\\-]"
        let validChars: NSRegularExpression
        do {
            validChars = try NSRegularExpression(pattern: validCharsPattern, options: NSRegularExpressionOptions(rawValue: 0))
        } catch _ {
            return false
        }
        
        let validMatches = validChars.matchesInString(diceString, options: NSMatchingOptions(rawValue: 0), range: range)
        
        return validMatches.count == diceString.characters.count
    }
    
    private static func replaceMinusWithPlusMinus (diceString:String) -> String {
        let minusSearch: NSRegularExpression?
        do {
            minusSearch = try NSRegularExpression(pattern: "\\-", options: NSRegularExpressionOptions(rawValue: 0))
        } catch _ {
            minusSearch = nil
        }
        let range = NSMakeRange(0, diceString.characters.count)
        let replacedDiceString = minusSearch!.stringByReplacingMatchesInString(diceString, options: NSMatchingOptions(rawValue: 0), range: range, withTemplate: "+-")
        
        return replacedDiceString ?? diceString
    }
    
    private static func parseSegment (segment segment:String, inout diceCollection:DiceCollection?) {
        if (diceCollection == nil) {
            return Void()
        }
        
        let nsStringSegment = segment as NSString
        let dicePattern = "^\\d+d\\d+$"
        let diceSearch: NSRegularExpression?
        do {
            diceSearch = try NSRegularExpression(pattern: dicePattern, options: NSRegularExpressionOptions(rawValue: 0))
        } catch _ {
            diceSearch = nil
        }
        let range = NSMakeRange(0, nsStringSegment.length)
        let diceMatchRanges = diceSearch!.matchesInString(segment, options: NSMatchingOptions(rawValue: 0), range: range)
        let diceMatchResults = diceMatchRanges.map { nsStringSegment.substringWithRange($0.range) }
        let numberOfDiceMatches = diceMatchResults.count
        
        if (numberOfDiceMatches == 0) {
            // try to match digits
            let digitPattern = "^\\-?\\d+$"
            let digitSearch: NSRegularExpression?
            do {
                digitSearch = try NSRegularExpression(pattern: digitPattern, options: NSRegularExpressionOptions(rawValue: 0))
            } catch _ {
                digitSearch = nil
            }
            let digitMatchRanges = digitSearch!.matchesInString(segment, options: NSMatchingOptions(rawValue: 0), range: range)
            let digitMatchResults = digitMatchRanges.map { nsStringSegment.substringWithRange($0.range) }
            let numberOfDigitMatches = digitMatchResults.count
            
            if (numberOfDigitMatches == 1) {
                //parse digits
                let constant = Int(digitMatchResults[0]) ?? 0
                diceCollection!.constant += constant
            } else {
                // error
                diceCollection = nil
                return Void()
            }
            
        } else if (numberOfDiceMatches == 1) {
            // string as dice set
            let diceString = diceMatchResults[0]
            let diceComponents = split(diceString.characters) { $0 == "d" }.map { String($0) }
            
            if (diceComponents.count == 2) {
                let diceCount = UInt(diceComponents[0]) ?? 0
                let dieFaces = UInt(diceComponents[1]) ?? 1
                diceCollection!.addDieWithFaces( dieFaces, numberOfTimes: diceCount)
            } else {
                // error
            }
            
        } else {
            // error?
        }
    }
}