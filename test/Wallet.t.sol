// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract WalletTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet{value: 100 ether}();
    }

    // setOwner tests
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

    // receive tests
    function print_WalletTest_Balance() public view {
        console.log("WalletTest balance", address(this).balance / 1e18);
    }

    function print_Wallet_Balance() public view {
        console.log("Wallet balance", address(wallet).balance / 1e18);
    }

    // any contract that receives amount will trigger this function. It must need to be defined in contract to recieve external amount
    receive() external payable {
        console.log("receive", msg.value);
    }

    function sendEther(uint256 amount) public payable {
        (bool success, ) = address(wallet).call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function test_receive() public {
        uint256 initialBalance = address(wallet).balance;
        // send ether to the wallet from WalletTest contract
        print_WalletTest_Balance(); // It will print default amount which test contracts has for testing
        sendEther(2 ether);
        print_Wallet_Balance();
        print_WalletTest_Balance();

        // send ether to the wallet using deal
        deal(address(1), 5 ether);
        vm.prank(address(1));
        sendEther(5 ether);
        print_Wallet_Balance();

        // send ether to the wallet using hoax
        hoax(address(1), 10 ether);
        sendEther(7 ether);
        print_Wallet_Balance();

        assertEq(
            address(wallet).balance,
            initialBalance + 2 ether + 5 ether + 7 ether
        );
    }

    // withdraw tests
    function test_withdraw_NotOwner() public {
        vm.expectRevert();
        vm.prank(address(0x456));
        wallet.withdraw(2 ether);
    }

    function test_withdraw() public {
        uint256 initialBalance = address(wallet).balance;

        print_WalletTest_Balance();
        print_Wallet_Balance();

        wallet.withdraw(2 ether);
        assertEq(address(wallet).balance, initialBalance - 2 ether);

        print_WalletTest_Balance();
        print_Wallet_Balance();
    }
}
