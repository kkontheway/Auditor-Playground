//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../../../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "./Vault.sol";

contract BaseToken is ERC20, Ownable {
    using SafeERC20 for ERC20;

    constructor() public ERC20("BaseToken", "Bas") {}

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
}
