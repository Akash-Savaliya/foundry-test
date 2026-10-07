// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import {Test} from "forge-std/Test.sol";
import {Transfer} from "../src/Transfer.sol";

contract TransferTest is Test {
    Transfer public transferE;

    event TransferSuccess(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        transferE = new Transfer();
    }

    function test_TransferSuccess() public {
        vm.expectEmit(true, true, false, true);
        emit TransferSuccess(address(this), address(1), 100);
        transferE.transer(address(this), address(1), 100);
    }

    function test_test_Transfer_Partial() public {
        vm.expectEmit(true, false, false, false);
        emit TransferSuccess(address(this), address(1), 100);
        transferE.transer(address(this), address(2), 500);
    }

    function test_Transfer_Many() public {
        address[] memory to = new address[](2);
        to[0] = address(1);
        to[1] = address(2);
        uint256[] memory amount = new uint256[](2);
        amount[0] = 100;
        amount[1] = 200;

        for (uint256 i = 0; i < to.length; i++) {
            vm.expectEmit(true, true, false, true);
            emit TransferSuccess(address(this), to[i], amount[i]);
            transferE.transer(address(this), to[i], amount[i]);
        }
    }
}
