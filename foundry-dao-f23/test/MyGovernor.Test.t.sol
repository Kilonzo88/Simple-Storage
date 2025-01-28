// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {Circle} from "../src/Circle.sol";
import {GovToken} from "../src/GovToken.sol";
import {TimeLock} from "../src/TimeLock.sol";

contract MyGovernorTest is Test {
    MyGovernor governor;
    Circle circle;
    GovToken govToken;
    TimeLock timelock;

    address public USER = makeAddr("user");
    uint256 public constant INITIAL_SUPPLY = 100 ether;
    
    address [] proposers;
    address [] executors;
    uint256 [] values;
    bytes [] calldatas;
    address[] targets;

    uint256 public constant MIN_DELAY = 3600; // 1 hour after a vote passes before we can execute
    uint256 public constant VOTING_DELAY = 7200; // 1 block till a vote is active
    uint256 public constant VOTING_PERIOD = 50400; // length of period in which people can cast vote

    function setUp() public {
        govToken = new GovToken();
        govToken.mint(USER, INITIAL_SUPPLY);
        
        vm.startPrank(USER);
        govToken.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executors);
        governor = new MyGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, USER);
        vm.stopPrank();

        circle = new Circle();
        circle.transferOwnership(address(timelock)); //timelock owns the DAO
    }

    function testCanUpdateCircleWithoutGovernance() public {
        vm.expectRevert();
        circle.store(1);
    }

    function testGovernanceUpdatesCircle() public {
        uint256 valueToStore = 888;
        string memory description = "store 1 in Circle";
        bytes memory encodedFunctionCall = abi.encodeWithSignature("store(uint256)", valueToStore);
        values.push(0);
        calldatas.push(encodedFunctionCall);
        targets.push(address(circle));


        //1. propose to the DAO
        uint256 proposalId = governor.propose(targets, values, calldatas, description);

        //View the state
        console.log("ProposalState 1: ", uint256(governor.state(proposalId)));

        govToken = new GovToken();
        govToken.mint(USER, INITIAL_SUPPLY);
        
        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.number + VOTING_DELAY + 1);

        console.log("ProposalState 2: ", uint256(governor.state(proposalId)));

        //2. Vote on the proposal
        string memory reason = "Cuz I'm an innovator";

        uint8 voteWay = 1; //Voting For the proposal
        vm.prank(USER);
        governor.castVoteWithReason(proposalId, voteWay, reason);

        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        vm.roll(block.number + VOTING_PERIOD + 1);

        //3. Queue the Tx
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        governor.queue(targets, values, calldatas, descriptionHash);
 
        vm.warp(block.timestamp + MIN_DELAY + 1);
        vm.roll(block.number + MIN_DELAY + 1);

        //4. Execute the Tx 
        governor.execute(targets, values, calldatas, descriptionHash);

        assert(circle.getNumber() == valueToStore);
        console.log("Circle Value:", circle.getNumber());
    }

    
}