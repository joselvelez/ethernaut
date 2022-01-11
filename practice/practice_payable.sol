pragma solidity ^0.5.12;

contract Wallet {
    address payable public owner;

    event Deposit(address sender, uint amount, uint balance);
    event Withdraw(uint amount, uint balance);
    event Transfer(address to, uint amount, uint balance);

    constructor() public payable {
        // allow for depositing to the contract when it is created
        // cannot deposit ether to the contract when deployed if 'payable' is omitted
        owner = msg.sender;
    }

    function deposit() public payable {
        // 'address(this).balance' does the folowing:
        // 1. 'this' refers to the contract
        // 2. 'address(this)' casts 'this' to an address type
        // 3. '.balance' gets the amount of ether in the contract after the deposit
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function notPayable() public {

    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function withdraw(uint _amount) public onlyOwner {
        // Use the .transfer method
        // https://docs.soliditylang.org/en/v0.5.15/units-and-global-variables.html#members-of-address-types
        owner.transfer(_amount);
        emit Withdraw(_amount, address(this).balance);
    }

    function transferEtherFromContract(address payable _to, uint _amount) public onlyOwner {
        _to.transfer(_amount);
        emit Transfer(_to, _amount, address(this).balance);
    }

    // Helper function to get the balance stored in the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}