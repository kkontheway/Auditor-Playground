// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

contract Vulnerable {
    mapping(address => uint256) private balances;

    function transfer(address to, uint256 amount) public {
        if (balances[msg.sender] >= amount) {
            balances[to] += amount;
            balances[msg.sender] -= amount;
        }
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
        balances[msg.sender] = 0;
    }
}
