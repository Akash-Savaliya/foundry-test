// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

contract Transfer {
    event TransferSuccess(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    function transer(address from, address to, uint256 amount) public {
        emit TransferSuccess(from, to, amount);
    }

    function transferMany(
        address from,
        address[] calldata to,
        uint256[] calldata amount
    ) public {
        for (uint256 i = 0; i < to.length; i++) {
            emit TransferSuccess(from, to[i], amount[i]);
        }
    }
}
