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
    
    var parser:DiceStringParser = DiceStringParser();
    
    override func setUp() {
        parser = DiceStringParser();
    }
    
    func testParseDiceString () {
        var dice:DiceCollection;
        
        dice = parser.parseDiceString("3d6+2");

        XCTAssertFalse(dice.dice.isEmpty, "Dice Array should contain some dice" );
        XCTAssertEqual(dice.numberOfDice, 3, "Creates the correct number of dice.");
        if (dice.numberOfDice >= 3) {
            XCTAssertEqual(dice.dice[0].sides, 6, "Creates die 0");
            XCTAssertEqual(dice.dice[1].sides, 6, "Creates die 1");
            XCTAssertEqual(dice.dice[2].sides, 6, "Creates die 2");
        }
        XCTAssertEqual(dice.minValue, 5, "MinValue checks out.");
        XCTAssertEqual(dice.maxValue, 20, "MaxValue checks out.");
        XCTAssertEqual(dice.constant, 2, "Creates the correct constant.");
        
        dice = parser.parseDiceString("1d2+2d3+3d4");
        
        XCTAssertFalse(dice.dice.isEmpty, "Dice Array should contain some dice" );
        XCTAssertEqual(dice.numberOfDice, 6, "Creates the correct number of dice.");
        if (dice.numberOfDice >= 6) {
            XCTAssertEqual(dice.dice[0].sides, 2, "Creates die 0");
            XCTAssertEqual(dice.dice[1].sides, 3, "Creates die 1");
            XCTAssertEqual(dice.dice[4].sides, 4, "Creates die 4");
        }
        XCTAssertEqual(dice.minValue, 6, "MinValue checks out.");
        XCTAssertEqual(dice.maxValue, 20, "MaxValue checks out.");
        XCTAssertEqual(dice.constant, 0, "Creates the correct constant.");
        
        dice = parser.parseDiceString("3");
        
        XCTAssertTrue(dice.dice.isEmpty, "Dice Array should be empty" );
        XCTAssertEqual(dice.numberOfDice, 0, "Creates no dice.");
        XCTAssertEqual(dice.minValue, 3, "MinValue checks out.");
        XCTAssertEqual(dice.maxValue, 3, "MaxValue checks out.");
        XCTAssertEqual(dice.constant, 3, "Creates the correct constant.");
        
        dice = parser.parseDiceString("1d6-3");
        XCTAssertFalse(dice.dice.isEmpty, "Dice Array should contain some dice" );
        XCTAssertEqual(dice.numberOfDice, 1, "Creates the correct number of dice.");
        if (dice.numberOfDice >= 1) {
            XCTAssertEqual(dice.dice[0].sides, 6, "Creates die 0");
        }
        XCTAssertEqual(dice.minValue, -2, "MinValue checks out.");
        XCTAssertEqual(dice.maxValue, 3, "MaxValue checks out.");
        XCTAssertEqual(dice.constant, -3, "Creates the correct constant.");
    }
    
    func testParseDiceStringEdgeCases () {
        var dice:DiceCollection;
        
        // fails (no die count)
        dice = parser.parseDiceString("d6");
        // fails (no faces for die)
        dice = parser.parseDiceString("3d");
        // fails (unsupported character)
        dice = parser.parseDiceString("3d6+x");
     
        // ignore whitespace
        dice = parser.parseDiceString("3d 6+ 1");
        
        // empty string evaluates to 0 dice, 0 constant
        dice = parser.parseDiceString("");
        XCTAssertTrue(dice.dice.isEmpty, "Dice Array should contain some dice" );
        XCTAssertEqual(dice.numberOfDice, 0, "Creates the correct number of dice.");
        XCTAssertEqual(dice.minValue, 0, "MinValue checks out.");
        XCTAssertEqual(dice.maxValue, 0, "MaxValue checks out.");
        XCTAssertEqual(dice.constant, 0, "Creates the correct constant.");
    }
}