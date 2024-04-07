//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../../src/Reentrancy/CrossContract-Re/EvilERC20.sol";
import "../../src/Reentrancy/CrossContract-Re/ICOGov.sol";
import "../../src/Reentrancy/CrossContract-Re/Vault.sol";
import "../../src/Reentrancy/CrossContract-Re/GOVToken.sol";
import "../../src/Reentrancy/CrossContract-Re/BaseToken.sol";

contract CrossContractTest is Test {
    ICOGov icoGov;
    EvilERC20 evilERC20;
    Vault vault;
    BaseToken baseToken;

    function setUp() public {
        baseToken = new BaseToken();

        GOVToken govToken = new GOVToken();
        icoGov = new ICOGov(govToken, vault, address(this), 1 ether);
        evilERC20 = new EvilERC20(vault, icoGov, govToken);
    }
}
