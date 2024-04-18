//SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {SimpleDapp} from "../../src/Fuzz/stateless.sol";

pragma solidity ^0.8.23;

/// @title Test for SimpleDapp Contract
/// @notice This contract implements FUzz testing for SimpleDapp
contract SimpleDappTest is Test {
    SimpleDapp simpleDapp;
    address public user;

    ///@notice Set up the test by deploying SimpleDapp
    function setUp() public {
        simpleDapp = new SimpleDapp();
        user = address(this);
    }

    function testDepositAndWithdraw(uint256 depositAmount, uint256 withdrawAmount) public payable {
        uint256 initiaUserBalance = 100 ether;
        vm.deal(user, initiaUserBalance);

        if (depositAmount <= initiaUserBalance) {
            simpleDapp.deposit{value: depositAmount}();

            if (withdrawAmount <= depositAmount) {
                simpleDapp.withdraw(withdrawAmount);
                assertEq(simpleDapp.balances(user), initiaUserBalance - withdrawAmount);
            } else {
                vm.expectRevert("Insufficent balance");
                simpleDapp.withdraw(withdrawAmount);
            }
        }
    }
}
