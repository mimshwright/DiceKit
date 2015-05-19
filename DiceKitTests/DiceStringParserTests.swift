//
//  DiceStringParserTests.swift
//  Dragon Dice
//
//  Created by Mims Wright on 5/13/15.
//  Copyright (c) 2015 Mims Wright. All rights reserved.
//

import UIKit
import XCTest

class DiceStringParserTests: XCTestCase {
    
    func testParseDiceString () {
        var diceOrNil:DiceCollection?
        var dice:DiceCollection
        
        
        diceOrNil = DiceStringParser.parseDiceString("3d6+2")
        XCTAssertNotNil (diceOrNil, "DiceCollection should not be nil")
        dice = diceOrNil!
        
        XCTAssertFalse(dice.dice.isEmpty, "Dice Array should contain some dice" )
        XCTAssertEqual(dice.numberOfDice, 3, "Creates the correct number of dice.")
        if (dice.numberOfDice >= 3) {
            XCTAssertEqual(dice.dice[0].sides, 6, "Creates die 0")
            XCTAssertEqual(dice.dice[1].sides, 6, "Creates die 1")
            XCTAssertEqual(dice.dice[2].sides, 6, "Creates die 2")
        }
        XCTAssertEqual(dice.minValue, 5, "MinValue checks out.")
        XCTAssertEqual(dice.maxValue, 20, "MaxValue checks out.")
        XCTAssertEqual(dice.constant, 2, "Creates the correct constant.")
        
        
        
        diceOrNil = DiceStringParser.parseDiceString("1d2+2d3+3d4")
        XCTAssertNotNil (diceOrNil, "DiceCollection should not be nil")
        dice = diceOrNil!
        
        XCTAssertFalse(dice.dice.isEmpty, "Dice Array should contain some dice" )
        XCTAssertEqual(dice.numberOfDice, 6, "Creates the correct number of dice.")
        if (dice.numberOfDice >= 6) {
            XCTAssertEqual(dice.dice[0].sides, 2, "Creates die 0")
            XCTAssertEqual(dice.dice[1].sides, 3, "Creates die 1")
            XCTAssertEqual(dice.dice[4].sides, 4, "Creates die 4")
        }
        XCTAssertEqual(dice.minValue, 6, "MinValue checks out.")
        XCTAssertEqual(dice.maxValue, 20, "MaxValue checks out.")
        XCTAssertEqual(dice.constant, 0, "Creates the correct constant.")
        
        
        
        diceOrNil = DiceStringParser.parseDiceString("3")
        XCTAssertNotNil (diceOrNil, "DiceCollection should not be nil")
        dice = diceOrNil!
        
        XCTAssertTrue(dice.dice.isEmpty, "Dice Array should be empty" )
        XCTAssertEqual(dice.numberOfDice, 0, "Creates no dice.")
        XCTAssertEqual(dice.minValue, 3, "MinValue checks out.")
        XCTAssertEqual(dice.maxValue, 3, "MaxValue checks out.")
        XCTAssertEqual(dice.constant, 3, "Creates the correct constant.")
        
        
        
        diceOrNil = DiceStringParser.parseDiceString("-5")
        XCTAssertNotNil (diceOrNil, "DiceCollection should not be nil")
        dice = diceOrNil!
        
        XCTAssertTrue(dice.dice.isEmpty, "Dice Array should be empty" )
        XCTAssertEqual(dice.numberOfDice, 0, "Creates no dice.")
        XCTAssertEqual(dice.minValue, -5, "MinValue checks out.")
        XCTAssertEqual(dice.maxValue, -5, "MaxValue checks out.")
        XCTAssertEqual(dice.constant, -5, "Creates the correct constant.")
        
        
        
        diceOrNil = DiceStringParser.parseDiceString("1d6-3")
        XCTAssertNotNil (diceOrNil, "DiceCollection should not be nil")
        dice = diceOrNil!
        
        XCTAssertFalse(dice.dice.isEmpty, "Dice Array should contain some dice" )
        XCTAssertEqual(dice.numberOfDice, 1, "Creates the correct number of dice.")
        if (dice.numberOfDice >= 1) {
            XCTAssertEqual(dice.dice[0].sides, 6, "Creates die 0")
        }
        XCTAssertEqual(dice.minValue, -2, "MinValue checks out.")
        XCTAssertEqual(dice.maxValue, 3, "MaxValue checks out.")
        XCTAssertEqual(dice.constant, -3, "Creates the correct constant.")
    }
    
    func testParseDiceStringEdgeCases () {
        var diceOrNil:DiceCollection?
        var dice:DiceCollection
        
        // fails (no die count)
        diceOrNil = DiceStringParser.parseDiceString("d6");
        XCTAssertNil(diceOrNil, "Parser should fail on missing die count")
        
        // fails (no separators between 2 sets of dice)
        diceOrNil = DiceStringParser.parseDiceString("3d61d12");
        XCTAssertNil(diceOrNil, "Parser should fail on ambiguous dice string")
        
        // fails (can't subtract dice)
        diceOrNil = DiceStringParser.parseDiceString("2d4-1d6");
        XCTAssertNil(diceOrNil, "Parser should fail on dice subtraction")
        
        // fails (no faces for die)
        diceOrNil = DiceStringParser.parseDiceString("3d");
        XCTAssertNil(diceOrNil, "Parser should fail on missing dice face number")
        
        // fails (unsupported character)
        diceOrNil = DiceStringParser.parseDiceString("3d6+x");
        XCTAssertNil(diceOrNil, "Parser should fail on unsupported character")
     
        // fails on whitespace
        diceOrNil = DiceStringParser.parseDiceString("3d 6+ 1");
        XCTAssertNil(diceOrNil, "Parser should fail on whitespace")
        
        // empty string evaluates to 0 dice, 0 constant
        diceOrNil = DiceStringParser.parseDiceString("")
        XCTAssertNotNil (diceOrNil, "DiceCollection should not be nil")
        dice = diceOrNil!

        XCTAssertTrue(dice.dice.isEmpty, "Dice Array should contain some dice" );
        XCTAssertEqual(dice.numberOfDice, 0, "Creates the correct number of dice.");
        XCTAssertEqual(dice.minValue, 0, "MinValue checks out.");
        XCTAssertEqual(dice.maxValue, 0, "MaxValue checks out.");
        XCTAssertEqual(dice.constant, 0, "Creates the correct constant.");
        
        // empty string evaluates to 0 dice, 0 constant
        dice = DiceStringParser.parseDiceString("1d6+1")!
        let diceUppercase = DiceStringParser.parseDiceString("1D6+1")!
        if (dice.numberOfDice >= 1 && diceUppercase.numberOfDice >= 1 ) {
            XCTAssertEqual(dice.dice[0].sides, diceUppercase.dice[0].sides, "Ignores case for dice strings")
        }
        XCTAssertEqual(dice.constant, diceUppercase.constant, "Ignores case for dice strings")
    }
}