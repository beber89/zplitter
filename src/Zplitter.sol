// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IERC20 {
    function transfer(address , uint256 ) external returns (bool );
    function balanceOf(address ) external returns (uint256 );
}

contract Zplitter {
    using SafeERC20 for IERC20;

    address[] stakeholders;

    error TooManyStakeholders();

    constructor (address[] memory _stakeholders) {
        if (_stakeholders.length > type(uint8).max)   revert TooManyStakeholders();
        stakeholders = _stakeholders;
    }

    function triggerPayout(IERC20 asset) {
        uint8 iters = _stakeholders.length;
        uint256 totalPayout = asset.balanceOf(address(this));
        uint256 stakeholderPayout = totalPayout/iters;

        for (uint8 i = 0;  i < iters; ) {
            asset.safeTransfer(stakeholders[i], stakeholderPayout);
            unchecked { i++; }
        }
    }

}
