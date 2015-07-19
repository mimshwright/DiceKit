//
//  Die.swift
//  Dragon Dice
//
//  Created by Mims Wright on 5/8/15.
//  Copyright (c) 2015 Mims Wright. All rights reserved.
//

import Foundation

public struct Die : Equatable {
    
    /**
        Number of sides / faces for this die. 
        Dice with `sides = N` generate random numbers between `1...N`
    */
    public let sides:UInt
    
    /**
        Constructor.
        :param: sides Number of sides for the die. Must be > 0.
    */
    public init(_ sides:UInt) {
        self.sides = UInt(max(1, sides))
    }
    
    /** 
        Generate a random result based on the number of sides of the die.
    
        :returns: A random result between `1...sides`
     */
    public func roll () -> Int {
        return 1 + Int(arc4random_uniform(UInt32(sides)))
    }
}

public typealias 🎲 = Die

public func ==(lhs: Die, rhs: Die) -> Bool {
    return lhs.sides == rhs.sides
}