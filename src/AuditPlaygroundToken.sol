// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;
/*
 * @Author: KK
 * @Date: 2024-04-09 16:46:14
 * @Description: Token for Mini-Exploit-Playground
 * Copyright (c) 2024 , All Rights Reserved. 
 */

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MiniToken is ERC20 {
    constructor() ERC20("AuditorPlayground", "APT") {
        _mint(msg.sender, type(uint256).max);
    }
}
