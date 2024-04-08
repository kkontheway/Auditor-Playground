// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

contract NormalReply {
    constructor() {}

    function transferFunds(address _to, uint256 _amount, uint8 _v, bytes32 _r, bytes32 _s) external {
        bytes32 messageHash = keccak256(abi.encodePacked(_to, _amount));
        address signer = ecrecover(messageHash, _v, _r, _s);
        require(signer == msg.sender, "Invalid signature");
        payable(_to).transfer(_amount);
    }
}
