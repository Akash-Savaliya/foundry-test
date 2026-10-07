// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import {Test} from "forge-std/Test.sol";
import {Error} from "../src/Error.sol";

contract ErrorTest is Test {
    Error public err;

    function setUp() public {
        err = new Error();
    }

    function test_ThrowError() public {
        vm.expectRevert(bytes("not authorized"));
        err.throwError();
    }

    function test_ThrowCustomError() public {
        vm.expectRevert(Error.NotAuthorized.selector);
        err.throwCustomError();
    }
}
