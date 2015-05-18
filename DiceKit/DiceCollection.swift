
//
//  DiceCollection.swift
//  Dragon Dice
//
//  Created by Mims Wright on 5/11/15.
//  Copyright (c) 2015 Mims Wright. All rights reserved.
//

import Foundation


public class DiceCollection {

    /**
        Array holding the dice in this collection.
     */
    public var dice:[Die];
    
    /**
        Derived property for number of dice in the collection.
     */
    public var numberOfDice:Int {
        get {
            return dice.count;
        }
    }

    /**
        A constant modifier added or subtracted from the rolled dice.
     */
    public var constant:Int = 0;
    
    
    /**
        Gets the maximum possible value for all the dice in the collection plus the constant modifier.
     */
    public var maxValue:Int {
        get {
            var max:Int = constant;
            for die in dice {
                max += Int(die.sides);
            }
            return max;
        }
    }
    
    /**
    * Gets the minimum possible value for all the dice in the collection including the constant modifier.
    */
    public var minValue:Int {
        get {
            return constant + numberOfDice;
        }
    }

    
    
    public init() {
        dice = [Die]();
    };
    
    public convenience init(constant:Int) {
        self.init();
        self.constant = constant;
    }
    
    public convenience init(dice:[Die], constant:Int = 0) {
        self.init(constant: constant);
        self.dice = dice;
    }
    
    
    /**
        Add the die multiple times.
        
        :param: die The Die to add.
        :param: numberOfTimes The number of times to add the die.
     */
    public func addDie(die:Die, numberOfTimes count:Int = 1) -> Void {
        for _ in 1...count {
            dice.append(die);
        }
    }
    
    /*
        Roll all dice.
    
        :returns: The results of rolling all dice in the collection including
        the constant modifier.
    */
    public func roll() -> Int {
        var sum:Int = constant;
        for die in dice {
            sum += die.roll();
        }
        return sum;
    }
    
}