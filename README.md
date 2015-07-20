# DiceKit

## Use
```Swift
// Create a die with 6 sides
let die:Die = Die(6)
// roll it
die.roll() // returns Int between 1 and 6
// You can create dice that don't exist in the real world
let thirteenSidedDie = Die(13)
// just for fun, you can create one with a game die emoji...
🎲(6).roll() // returns Int between 1 and 6

// Create a set of dice
var diceSet:DiceCollection = DiceCollection()
// add a die to it
diceSet.addDie(die, numberOfTimes: 3)
// add a constant modifier
diceSet.constant = 4
// roll them all and add modifier
diceSet.roll() // rolls 3d6+4 an Int between 7 and 22
// see the range of the DiceCollection
diceSet.minValue // 7
diceSet.maxValue // 22
// inspect the dice in the set
diceSet.numberOfDice // 3
diceSet.dice[0] // Die(6)

// create a diceCollection by adding dice and/or ints
diceSet = Die(8) + Die(6) + 5
diceSet.NumberOfDice // 2
diceSet.constant // 5
diceSet += Die(4)
diceSet.NumberOfDice // 3

// Create a DiceCollection using a string...
// this diceSet will be identical to the one above
diceSet = DiceStringParser.parseDiceString("3d6+4")
diceSet.roll() // rolls 3d6+4 an Int between 7 and 22
// DiceCollections can be converted back into strings using toDiceString()
diceSet.toDiceString() // "3d6+4"
```