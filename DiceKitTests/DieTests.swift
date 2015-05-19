//
//  DieTests.swift
//  Dragon Dice
//
//  Created by Mims Wright on 5/11/15.
//  Copyright (c) 2015 Mims Wright. All rights reserved.
//

import UIKit
import XCTest

class DieTests: XCTestCase {
    
    func testInit() {
        let die6 = Die(6);
        XCTAssertEqual(die6.sides, 6, "number of sides set by constructor");
        
        let die1 = Die(1);
        XCTAssertEqual(die1.sides, 1, "Die can have 1 sides");
        
        let die0 = Die(0);
        XCTAssertEqual(die0.sides, 1, "Die can never have fewer than 1 side");

    }
    
    func testRoll() {
        let die6 = Die(6);
        rollDie(die6, repetitions: 1000);
        
        let die100 = Die(100);
        rollDie(die100, repetitions: 1000);
        
        let die1 = Die(1);
        rollDie(die1, repetitions: 1000);
    }
    
    func rollDie (die:Die, repetitions:Int) {
        var min:UInt = 1;
        var max:UInt = 1;
        
        for _ in 1...repetitions {
            let roll = UInt(die.roll());
            if (roll > max) { max = roll; }
            if (roll < min) { min = roll; }
        }
        
        XCTAssertGreaterThanOrEqual(min, 1, "die with \(die.sides) sides rolls are never less than 1");
        XCTAssertLessThanOrEqual(max, die.sides, "die with \(die.sides) sides rolls are never more than number of sides");
    }
}
