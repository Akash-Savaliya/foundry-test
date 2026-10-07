// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

contract Auction {
    uint256 public startAt = block.timestamp + 1 days;
    uint256 public endAt = block.timestamp + 2 days;

    function bid() public view {
        require(block.timestamp >= startAt && block.timestamp < endAt, "cannot bid");
    }
}
