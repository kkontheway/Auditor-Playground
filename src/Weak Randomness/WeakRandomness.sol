// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract weakRandomness {
    bool public status;

    constructor() {}

    function random(uint256 GuessNumber) public {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))) % 100; // get bad random number
        require(randomNumber == GuessNumber, "Better luck next time!");
        status = true;
    }

    function isHacked() public view returns (bool) {
        return status;
    }
}
