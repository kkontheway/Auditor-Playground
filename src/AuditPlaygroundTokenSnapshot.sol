// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ERC20Snapshot, ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Snapshot.sol";

/**
 * @title AuditorplaygroundTokenSnapshot
 * @author kk
 */
contract AuditorplaygroundTokenSnapshot is ERC20Snapshot {
    uint256 private lastSnapshotId;

    constructor(uint256 initialSupply) ERC20("AuditorPlaygrounToken", "APT") {
        _mint(msg.sender, initialSupply);
    }

    function snapshot() public returns (uint256) {
        lastSnapshotId = _snapshot();
        return lastSnapshotId;
    }

    function getBalanceAtLastSnapshot(address account) external view returns (uint256) {
        return balanceOfAt(account, lastSnapshotId);
    }

    function getTotalSupplyAtLastSnapshot() external view returns (uint256) {
        return totalSupplyAt(lastSnapshotId);
    }
}
