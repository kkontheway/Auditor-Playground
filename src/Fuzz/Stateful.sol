// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

contract AlwaysEven {
    uint256 public alwaysEvenNumber;
    uint256 public hiddenValue;

    function setEvenNumber(uint256 inputNumber) public {
        if (inputNumber % 2 == 0) {
            alwaysEvenNumber += inputNumber;
        }

        // This conditional will break the invariant which must be always be even

        if (hiddenValue == 8) {
            alwaysEvenNumber = 3;
        }
        // We set the hiddenValue to the inputNumber at the end of the function
        // In a stateful scenario, this value will be remembered for the next call

        hiddenValue = inputNumber;
    }
}
