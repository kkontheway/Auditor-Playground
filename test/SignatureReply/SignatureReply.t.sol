// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/SignatureReply/Wallet.sol";
import "../../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import "../../src/MiniToken.sol";

contract SignatureReplyTest is Test {
    uint256 internal constant USER_TOKEN_BALANCE = 10_000;

    using ECDSA for bytes32;

    MiniToken internal mnt;
    Wallet wallet;
    uint256 internal OwnerPrivateKey = 0x1234;
    uint256 internal UserPrivateKey = 0x5678;
    address owner = vm.addr(OwnerPrivateKey);
    address user = vm.addr(UserPrivateKey);

    function setUp() public {
        // create wallet
        wallet = new Wallet(address(owner), address(mnt));

        mnt = new MiniToken();
        vm.label(address(mnt), "MNT");
        mnt.transfer(user, USER_TOKEN_BALANCE);
    }

    function testdeposit() public {
        vm.startPrank(user);
        wallet.deposit(1000);
        vm.stopPrank();
        console.log("User balance: ", wallet.mntBalances(user));
    }

    function testSignatureReply() public {
        uint256 amount = 500;
        bytes32 digest = keccak256(abi.encodePacked(user, amount)).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(OwnerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        vm.startPrank(user);
        wallet.withdraw(amount, signature);
        console.log("User balance: ", wallet.mntBalances(user));
    }

    function validation() public view {
        if (wallet.mntBalances(user) == 0) {
            console.log("is Solved: True");
        }
        console.log("is Solved: False");
    }
}
