pragma solidity ^0.8.11;

/*
    Reference
    - https://docs.soliditylang.org/en/v0.5.11/control-structures.html#external-function-calls
    - https://docs.soliditylang.org/en/v0.8.11/types.html#members-of-addresses
    
*/

/*
    * Functions of other contracts need to be called externally
    * A function call from one contract to another does not create its own transaction,
      it is a message call as part of the overall transaction
    * All function arguments for an external call must be copied to memory
    * You can send an arbitrary amount of wei or gas to the called function with
      .value() or .gas()
    * 

    call is a low level method available on the address type
    examples: 
        - call an existing function
        - call a non-existing function, which triggers the fallback function

    ** Not the recommend way to interact with contracts
*/

contract CallReceiver {
    event Response(address caller, uint amount, string message, uint gasLeft);

    fallback () external payable {
        emit Response(msg.sender, msg.value, "Fallback method triggered!", gasleft());
    }

    function calledFunction(string memory _message, uint _x) public payable returns (uint) {
        emit Response(msg.sender, msg.value, _message, gasleft());

        return _x + 1;
    }
}

contract CallSender {

    function sendCallWithData(address payable _to) public payable {
        bytes memory functionSignature = abi.encodeWithSignature("calledFunction(string,uint256)", "function message goes here", msg.value);

        (bool success, bytes memory data) = _to.call(functionSignature);
        require(success, "Transaction failed");
    }

    // Triggers fallback since no data is sent
    function sendCallWithNoData(address payable _to) public payable {
        (bool success, ) = _to.call{ value: msg.value } ("");
        require(success, "Transaction failed");
    }


    function sendCallWithModifiers(address payable _to) public payable {
        bytes memory functionSignature = abi.encodeWithSignature("calledFunction(string,uint256)", "this is the called function message", msg.value);

        (bool success, ) = _to.call{ gas: 5000000, value: msg.value } (functionSignature);
        require(success, "Nope, this did NOT work...");
    }

    // Call a non-existing function and trigger a fallback
    function sendCallWithBadFunction(address payable _to) public payable {
        bytes memory nonExistingFunction = abi.encodeWithSignature("nonExistingFunction()");

        (bool success, ) = _to.call(nonExistingFunction);
        require(success, "Tx failed");
    }
}

