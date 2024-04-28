// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../../lib/openzeppelin-contracts-upgradeable/contracts/utils/structs/EnumerableMapUpgradeable.sol";

contract BorrowerCanNotBeLiquidated {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    struct CollateralInfo {
        EnumerableSetUpgradeable.AddressSet collateralAddresses;
        mapping(address => uint256) collateralInfo;
    }

    mapping(uint256 => CollateralInfo) internal _loanCollaterals;

    function commitCollateral(uint256 loanId, address token, uint256 amount) external {
        CollateralInfo storage collateral = _loanCollaterals[loanId];

        collateral.collateralAddresses.add(token);
        collateral.collateralInfo[token] = amount;
    }

    function getCollateralAmount(uint256 loanId, address token) external view returns (uint256) {
        CollateralInfo storage collateral = _loanCollaterals[loanId];
        return collateral.collateralInfo[token];
    }
}
