
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import ERC20 token implementation from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Stake is ERC20 {
    constructor() ERC20("WCX Token", "WCX") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}