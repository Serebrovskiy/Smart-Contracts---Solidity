//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Payments {
  struct Payment {
    uint amount;
    uint timestamp;
    address from;
    string message;
  }

  struct Balance {
    uint totalPayments;
    mapping(uint => Payment) payments;
  }

  mapping(address => Balance) public balances;

  //считывает общий баланс на нашем контракте
  function currentBalance() public view returns(uint) {
    return address(this).balance;
  }

  //получает информацию о платеже
  function getPayment(address _addr, uint _index) public view returns (Payment memory){
    return balances[_addr].payments[_index];
  }

  //принимает денежные средства и сохраняет информацию о платеже
  function pay(string memory message) public payable {
    uint paymentNum = balances[msg.sender].totalPayments;
    balances[msg.sender].totalPayments++;
    
    Payment memory newPayment = Payment(
      msg.value,
      block.timestamp,
      msg.sender,
      message
    );

    balances[msg.sender].payments[paymentNum] = newPayment;
  }

}