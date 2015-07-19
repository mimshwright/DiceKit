//
//  DiceCollectionTests.swift
//  DiceCollectionTests
//
//  Created by Mims Wright on 5/8/15.
//  Copyright (c) 2015 Mims Wright. All rights reserved.
//

import UIKit
import XCTest

class DiceCollectionTests: XCTestCase {
    
    var dice_2d6p3 = DiceCollection();
    var dice_1d20 = DiceCollection();
    var dice_1d4p2d6p3d10m3 = DiceCollection();
    var dice_noDice3 = DiceCollection();
    var dice_empty = DiceCollection();
    
    override func setUp() {
        super.setUp()
        
        dice_1d20 = DiceCollection();
        dice_1d20.addDie(Die(20));
        
        // testing convenience init
        var d6 = Die(6);
        dice_2d6p3 = DiceCollection(dice: [d6,d6], constant: 3);
        
        // testing addDie with number of times
        dice_1d4p2d6p3d10m3 = DiceCollection();
        dice_1d4p2d6p3d10m3.addDie(Die(4));
        dice_1d4p2d6p3d10m3.addDie(Die(6), numberOfTimes: 2);
        dice_1d4p2d6p3d10m3.addDie(Die(10), numberOfTimes: 3);
        dice_1d4p2d6p3d10m3.constant = -3;
        
        // test init with constant
        dice_noDice3 = DiceCollection(constant: 3);
        
        // no dice or constant added
        dice_empty = DiceCollection();
    }
    
    
    func testMinValue() {
        XCTAssertEqual(dice_1d20.minValue, 1, "min 1d20 -> 1");
        XCTAssertEqual(dice_2d6p3.minValue, 5, "min 2d6+3 -> 5");
        XCTAssertEqual(dice_1d4p2d6p3d10m3.minValue, 3, "min 1d4+2d6+3d10-3 -> 3");
        XCTAssertEqual(dice_noDice3.minValue, 3, "min +3 -> 3");
        XCTAssertEqual(dice_empty.minValue, 0, "min (empty) -> 0");
    }
    
    func testMaxValue() {
        XCTAssertEqual(dice_1d20.maxValue, 20, "max 1d20 -> 20");
        XCTAssertEqual(dice_2d6p3.maxValue, 15, "max 2d6+3 -> 15");
        XCTAssertEqual(dice_1d4p2d6p3d10m3.maxValue, 43, "max 1d4+2d6+3d10-3 -> 43");
        XCTAssertEqual(dice_noDice3.maxValue, 3, "max +3 -> 3");
        XCTAssertEqual(dice_empty.maxValue, 0, "max (empty) -> 0");
    }
    
    func testNumberOfDice() {
        XCTAssertEqual(dice_1d20.numberOfDice, 1, "number of dice 1d20 -> 1");
        XCTAssertEqual(dice_2d6p3.numberOfDice, 2, "number of dice 2d6+3 -> 2");
        XCTAssertEqual(dice_1d4p2d6p3d10m3.numberOfDice, 6, "number of dice 1d4+2d6+3d10-3 -> 6");
        XCTAssertEqual(dice_noDice3.numberOfDice, 0, "number of dice +3 -> 0");
        XCTAssertEqual(dice_empty.numberOfDice, 0, "number of dice (empty) -> 0");
    }
    
    func testRoll() {
        let d1 = Die(1);
        let dc = DiceCollection(constant: 5);
        dc.addDie(d1, numberOfTimes: 10);
        XCTAssertEqual(dc.roll(), 15, "Roll should roll every die and add the constant");
    }
    
    func testOperators() {
        let dc = 🎲(6) + 🎲(4) + 2
        XCTAssertEqual(dc.numberOfDice, 2, "Die + Die = DiceCollection")
        XCTAssertEqual(dc.constant, 2, "DiceCollection + int = DiceCollection")
        
        XCTAssertEqual((dc + Die(4)).numberOfDice, 3, "DiceCollection + Die = DiceCollection")
        
        var dcPlusEquals = dc
        dcPlusEquals += Die(10)
        XCTAssertEqual(dcPlusEquals.numberOfDice, 3, "DiceCollection += Die")
        
        let dcPlusDc = dc + DiceCollection(dieFaces: 5, dieCount: 3, constant: 7)
        XCTAssertEqual(dcPlusDc.numberOfDice, 5, "DiceCollection + DiceCollection = DiceCollection")
        XCTAssertEqual(dcPlusDc.constant, 9, "DiceCollection + DiceCollection = DiceCollection")
        
        let diePlusConst = Die(4) + 2
        XCTAssertEqual(diePlusConst.constant, 2, "Die + int = DiceCollection")
        XCTAssertEqual(diePlusConst.numberOfDice, 1, "Die + int = DiceCollection")
        XCTAssertEqual((diePlusConst - 1).constant, 1, "Die - int = DiceCollection")
        
        XCTAssertEqual(🎲(4) + 2, DiceCollection(dieFaces: 4, dieCount: 1, constant: 2), "DiceCollection is Equatable")
        XCTAssertEqual(Die(4) + Die(6) + 3, Die(6) + 3 + Die(4), "Equality is commutable")
    }
}
