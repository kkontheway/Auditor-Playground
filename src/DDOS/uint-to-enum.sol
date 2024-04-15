// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

interface IntherfaceA {
    enum Enumerator {
        A,
        B,
        C
    }

    function enumCall() external returns (Enumerator);
}

contract DDOSContract {
    function enumCall() public returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}
}

contract InterfaceTest {
    IntherfaceA public targetContract;

    function test() public {
        //IntherfaceA(address(new DDOSContract())).enumCall();
        targetContract = IntherfaceA(address(new DDOSContract()));
        targetContract.enumCall();
    }

    function exploit() public {
        targetContract.enumCall();
    }
}
