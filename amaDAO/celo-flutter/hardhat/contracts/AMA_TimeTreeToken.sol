// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @notice Token to manage the AMA green credits "Trees"
 */
contract AMA_TimeTreeToken is ERC20 {
    uint planted;
    address payable owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() ERC20("AMA Time Tree Token", "TREE") {
        /// @notice mint 1,000,000 tokens to the owner (AMA) for 1M tree fund
        _mint(msg.sender, 1000000e18);
        owner = payable(msg.sender);
        planted = 0;
    }

    function plantRequest(uint amount)
        public
        payable
        returns (bool accepted)
    {
        require(amount == msg.value, "Invalid amount!");

        planted += msg.value;

        return true;
    }

    function fundBalance() public onlyOwner returns (bool) {
        bool success = owner.send(address(this).balance);

        if (success) return true;

        return false;
    }
}
