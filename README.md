# SimpleStorage Contract

## Overview

SimpleStorage is a basic Solidity smart contract designed to demonstrate fundamental blockchain data storage capabilities. The contract allows users to store and retrieve personal information, specifically names and favorite numbers, directly on the Ethereum blockchain.

## Features

- Store a personal favorite number
- Add people with their names and favorite numbers
- Maintain a list of people
- Map names to favorite numbers
- Retrieve stored information

## Contract Functions

- `store(uint256 _favoriteNumber)`: Stores a favorite number
- `retrieve()`: Retrieves the stored favorite number
- `addPerson(string memory _name, uint256 _favoriteNumber)`: Adds a person with their name and favorite number

## Data Structures

- `myFavoriteNumber`: Stores a single favorite number
- `listOfPeople`: An array of People
- `nameToFavoriteNumber`: A mapping connecting names to favorite numbers

## Prerequisites

- Solidity ^0.8.19
- Development Environment Options:
  - Visual Studio Code
  - Remix IDE

## Example Usage

```solidity
// Store a favorite number
simpleStorage.store(42);

// Add a person
simpleStorage.addPerson("Alice", 7);

// Retrieve favorite number
uint256 favoriteNumber = simpleStorage.retrieve();
```

## License

This project is licensed under the MIT License.
