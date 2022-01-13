// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract CoinFlip {

  event logBlockHash(string loggedBlockHash);

  using SafeMath for uint256;
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    emit logBlockHash(blockValue);

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}

/*
  Reference:
  - block.number (uint): current block number
  - blockhash(uint blockNumber) returns (bytes32): hash of the given block when blocknumber is one of the 256 most recent blocks; otherwise returns zero
  - SafeMath sub method: https://docs.openzeppelin.com/contracts/4.x/api/utils#SafeMath-sub-uint256-uint256-
  - Explicit Conversions
    0.8.11 Docs: https://docs.soliditylang.org/en/v0.8.11/types.html#explicit-conversions
    0.6.0 Docs: https://docs.soliditylang.org/en/v0.6.0/types.html#conversions-between-elementary-types
*/