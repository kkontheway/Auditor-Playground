// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import "./PrivateBank.sol";

contract RichGuyClub {
    PrivateBank bank;
    mapping(address => bool) public richguy;

    constructor(address _bankAddress) {
        bank = PrivateBank(_bankAddress);
    }

    function joinClub() public {
        require(getUserBalance() > 100 ether);
        richguy[msg.sender] = true;
    }

    function getUserBalance() public view returns (uint256) {
        uint256 userBalance = bank.userBalance(msg.sender);
        return userBalance;
    }
}
