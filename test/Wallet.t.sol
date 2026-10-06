// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract WalletTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    function test_SetOwner() public {
        wallet.setOwner(address(0x123));
        assertEq(wallet.owner(), address(0x123));
    }

    function test_SetOwner_NotOwner() public {
        console.log("owner", wallet.owner()); // WalletTest address
        console.log("msg.sender", msg.sender); // Forge Runner address
        vm.prank(address(0x456));
        vm.expectRevert();
        wallet.setOwner(address(111));
    }

    function test_setOwer_Again() public {
        wallet.setOwner(address(0x123)); // pass
        vm.prank(address(0x123));
        wallet.setOwner(address(0x456)); // pass
        assertEq(wallet.owner(), address(0x456)); // pass
    }

    function test_setOwer_Again_NotOwner() public {
        wallet.setOwner(address(0x123)); // pass

        vm.startPrank(address(0x123));
        wallet.setOwner(address(0x123));
        wallet.setOwner(address(0x123));
        wallet.setOwner(address(0x123));
        vm.stopPrank();

        console.log("owner", wallet.owner()); // 0x0000000000000000000000000000000000000123

        vm.expectRevert();
        wallet.setOwner(address(0x456));
    }
}
