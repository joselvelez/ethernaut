pragma solidity ^0.5.11;

/*
    3 ways to send ether from a contract to another contract
    - transfer (forwards 2300 gas, throws error)
    - send (forwards 2300 gas, return bool)
    ^^^ transfer and send guard against re-entrancy by forwarding only 2300 gas

    - call (forward all gas or set gas, return bool)
    ^^^ recommend for use after Dec 2019
    ^^^ guard against re-entrancy by making all state changes BEFORE calling another contract
    ^^^ also use modifiers to help guard against re-entrancy attacks
 */

contract ReceiveEther {
    // fallback
    function () external payable {

    }

    // helper function to check balance for contract 
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendEther {
    // Using transfer method
    function sendViaTransfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    // Using send method
    function SendViaSend(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "Fail to send Ether!");
    }

    // using the call method
    function SendViaCall(address payable _to) public payable {
        (bool sent, bytes memory data) = _to.call.value(msg.value)("");
        // ^^^ Forwards all of the gas that is sent to the address recieving the ether

        // (bool sent, bytes memory data) = _to.call.gas(1000).value(msg.value)("");
        // ^^^ Specify the amount of gas to foward

        /*
            Function returns two values.
            1. Bool indicating success sending Ether
            2. Holds the return values from calling the fallback function
            Since the fallback returns nothing, 'data' will be empty
        */
        require(sent, "Failed to send Ether");
    }
}