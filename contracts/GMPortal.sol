// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract GMPortal {
    uint256 totalGMs;
    mapping(address => uint256) userGMCount;
    mapping(address => uint256) public lastGMedAt;
    address public owner;

    event NewGM(address indexed from, uint256 timestamp, string message);

    struct GM {
        address GMer;
        string message;
        uint256 timestamp;
    }

    GM[] gms;

    constructor() payable {
        console.log("Yo, this is the GM Portal Contract. GM!");
        owner = msg.sender;
    }

    function sayGM(string memory _message) public {
        require(
            lastGMedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15 minutes"
        );
        lastGMedAt[msg.sender] = block.timestamp;

        totalGMs += 1;
        userGMCount[msg.sender] += 1;
        console.log("%s has GMed with message %s", msg.sender, _message);

        gms.push(GM(msg.sender, _message, block.timestamp));
        emit NewGM(msg.sender, block.timestamp, _message);
    }

    //TODO: test rewardGMer in run.js

    function rewardGMer(address _gmer) public onlyOwner {
        uint256 rewardAmount = 0.0001 ether;
        console.log("Reward amount: %s", rewardAmount);

        require(
            rewardAmount <= address(this).balance,
            "You don't have enough ether to pay for the reward."
        );
        (bool success, ) = (_gmer).call{value: rewardAmount}("");
        require(success, "Failed to send money from contract to rewardee");
        console.log("Rewarded %s with %s wei", _gmer, rewardAmount);
    }

    function getTotalGMs() public view returns (uint256) {
        console.log("We have %d total GMs!", totalGMs);
        console.log("You have GMed %d of the GMs", userGMCount[msg.sender]);
        return totalGMs;
    }

    function getAllGMs() public view returns (GM[] memory) {
        return gms;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this.");
        _;
    }
}
