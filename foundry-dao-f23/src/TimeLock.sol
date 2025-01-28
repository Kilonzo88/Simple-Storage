// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {TimelockController} from "@openzeppelin/governance/TimelockController.sol";

contract TimeLock is TimelockController{
    //How long you have to wait before executing
    //Proposers is the list of accounts that can propose
    // executors is the list of addresses that can execute

    constructor(uint256 minDelay, address [] memory proposers, address [] memory executors) TimelockController(minDelay, proposers, executors, msg.sender){
        
    }
}