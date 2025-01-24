// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorage} from "src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public simpleStorage;

    function setUp() public {
        simpleStorage = new SimpleStorage();
    }

    function testInitialValueIsZero() view public {
        assertEq(simpleStorage.retrieve(), 0, "Initial favorite number should be zero");
    }

    function testStoreFunction() public {
        uint256 expectedNumber = 42;
        simpleStorage.store(expectedNumber);
        assertEq(simpleStorage.retrieve(), expectedNumber, "Stored number should match retrieved number");
    }

    function testAddPerson() public {
        string memory name = "Alice";
        uint256 favoriteNumber = 7;
        
        simpleStorage.addPerson(name, favoriteNumber);
        
        (uint256 storedFavoriteNumber, string memory storedName) = simpleStorage.listOfPeople(0);
        
        assertEq(storedFavoriteNumber, favoriteNumber, "Stored favorite number should match");
        assertEq(storedName, name, "Stored name should match");
        assertEq(simpleStorage.nameToFavoriteNumber(name), favoriteNumber, "Name to favorite number mapping should work");
    }

    function testNameToFavoriteNumber() public {
        string memory name = "Charlie";
        uint256 favoriteNumber = 99;
        
        simpleStorage.addPerson(name, favoriteNumber);
        
        assertEq(simpleStorage.nameToFavoriteNumber(name), favoriteNumber, "Name to favorite number mapping should work correctly");
    }
}