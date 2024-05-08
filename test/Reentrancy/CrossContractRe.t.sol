//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../../src/Reentrancy/CrossContractReentrancy/EvilERC20.sol";
import "../../src/Reentrancy/CrossContractReentrancy/ICOGov.sol";
import "../../src/Reentrancy/CrossContractReentrancy/Vault.sol";
import "../../src/Reentrancy/CrossContractReentrancy/GOVToken.sol";
import "../../src/Reentrancy/CrossContractReentrancy/BaseToken.sol";

contract CrossContractTest is Test {
    IRouter router = IRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    ICOGov icoGov;
    EvilERC20 evilERC20;
    Vault vault;
    BaseToken baseToken;
    GOVToken govToken;

    function setUp() public {
        vm.createSelectFork("polygon", 56_628_286);

        baseToken = new BaseToken();
        govToken = new GOVToken();

        vault = new Vault(baseToken, router);
        icoGov = new ICOGov(govToken, vault, address(this), 1 ether);

        evilERC20 = new EvilERC20(vault, icoGov, govToken);
    }
}
