pragma solidity ^0.5.11;

contract Fallback {

    event Log(uint gas);

    function () external payable {

        // Recommend to NOT add any logic to a fallback funcion.
        // send / transfer methods only forwards 2300 gas to this fallback function,
        // that only provides enough gas to emit a log, not enough to write to storage 
        // or call another contract

        emit Log(gasleft());
        // Global variable: gasleft() returns (uint256): remaining gas
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallBack(address payable _to) public payable {
        (bool sent,) = _to.call.value(msg.value) ("");
        require(sent, "Failed to send Ether");
    }

    function callFallBackWithGasSet(address payable _to, uint gasAmount) public payable {
        (bool sent, ) = _to.call.gas(gasAmount).value(msg.value) ("");
        require(sent, "Failed to send Ether");
    }
}