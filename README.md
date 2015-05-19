# DiceKit

## Use
```Swift
// Create a die with 6 sides
var die:Die = Die(6)
// roll it
die.roll() // returns Int between 1 and 6

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


// Create a DiceCollection using a string...
// this diceSet will be identical to the one above
diceSet = DiceStringParser.parseDiceString("3d6+4")
diceSet.roll() // rolls 3d6+4 an Int between 7 and 22
```