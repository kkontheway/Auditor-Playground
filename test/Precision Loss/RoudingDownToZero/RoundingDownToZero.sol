// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "../../../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";
import "forge-std/Test.sol";

contract RoundingDownToZero is Test {
    uint256 public loanAmount = 10 ether;
    uint256 public loanCollateral = 1 ether;

    function setUp() public {
        // 1. Set up the state of the contract
    }

    // source: https://github.com/sherlock-audit/2022-12-notional-judging/issues/16
}
