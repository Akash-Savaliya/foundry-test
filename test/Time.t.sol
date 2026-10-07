// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;

import "forge-std/Test.sol";
import {Auction} from "../src/Time.sol";

contract TimeTest is Test {
    Auction public auction;
    uint256 public blockTimeStamp;

    function setUp() public {
        auction = new Auction();
        blockTimeStamp = block.timestamp;
    }

    function test_Bid_Fail_Before_StartTime() public {
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    function test_Bid_Pass_After_StartTime() public {
        vm.warp(blockTimeStamp + 1 days);
        auction.bid();
    }

    function test_Bid_Fail_After_EndTime() public {
        vm.warp(blockTimeStamp + 2 days);
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }
}
