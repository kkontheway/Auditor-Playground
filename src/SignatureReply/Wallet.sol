// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Wallet {
    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event Withdraw(address indexed sender, uint256 amount, uint256 balance);

    mapping(address => mapping(address => uint256)) public tokenBalances;

    using ECDSA for bytes32;

    address public owner;
    IERC20 public mnt;
    mapping(address => uint256) public mntBalances;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _owners, address tokenaddress) payable {
        require(_owners != address(0), "invalid owner");
        owner = _owners;
        mnt = IERC20(tokenaddress);
    }

    receive() external payable {}

    function deposit(uint256 amount) external payable {
        require(amount > 0, "value required");
        require(mnt.transferFrom(msg.sender, address(this), amount), "transfer failed");
        mntBalances[msg.sender] += amount;
    }

    function withdraw(uint256 _amount, bytes calldata _signature) external {
        require(
            isValidSignature(owner, keccak256(abi.encodePacked(msg.sender, _amount)), _signature), "Invalid Signature"
        );
        mntBalances[msg.sender] -= _amount;
        require(mnt.transfer(msg.sender, _amount), "MVT transfer failed");

        emit Withdraw(msg.sender, _amount, address(this).balance);
    }

    function isValidSignature(address _OwnerAddress, bytes32 hash, bytes memory signature)
        internal
        view
        returns (bool)
    {
        require(_OwnerAddress != address(0), "Missing System Address");

        bytes32 signedHash = hash.toEthSignedMessageHash();
        return signedHash.recover(signature) == address(owner);
    }
}
