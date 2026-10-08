// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import {Test, console} from "forge-std/Test.sol";

contract SignTest is Test {
    function test_Sign() public pure {
        uint256 privateKey = 123;
        address publicKey = vm.addr(privateKey);
        bytes32 hash = keccak256(abi.encodePacked("Secret Message"));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, hash);
        assertEq(publicKey, ecrecover(hash, v, r, s));

        bytes32 hash2 = keccak256(abi.encodePacked("Secret Message 2"));
        address signer = ecrecover(hash2, v, r, s);
        assertTrue(signer != publicKey);
    }
}
