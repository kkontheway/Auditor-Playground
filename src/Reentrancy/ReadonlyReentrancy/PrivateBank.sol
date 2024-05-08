// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

contract PrivateBank {
    bool private lock;
    mapping(address => uint256) public userBalance;

    uint256 totalBalance;

    modifier NonReentrant() {
        require(!lock);
        lock = true;
        _;
        lock = false;
    }

    function deposit() public payable NonReentrant {
        userBalance[msg.sender] += msg.value;
        totalBalance += msg.value;
    }

    function withdrawAll() public NonReentrant {
        uint256 balance = userBalance[msg.sender];
        require(balance > 0);
        totalBalance -= balance;
        (bool done,) = msg.sender.call{value: balance}("");
        require(done);
        userBalance[msg.sender] = 0;
    }
}
