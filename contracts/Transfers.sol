// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Transfers {
  struct Transfer {
    uint amount;
    uint timestamp;
    address sender;
  }

  Transfer[] transfers;

  address owner;
  uint8 maxTransfers; //макс кол-во контрактов
  uint8 currentTransfers;

  constructor(uint8 _maxTransfers) {
    owner = msg.sender;
    maxTransfers = _maxTransfers;
  }

  //функ-ия для чтения информации о конкретном трансфере
  function getTransfer(uint _index) public view returns(Transfer memory) {
    require(_index < transfers.length, "Cannot find this transfer.");

    return transfers[_index];
  }

  //модификатор проверки что owner является владельцем
  modifier requireOwner() {
    require(owner == msg.sender, "Not an owner");
    _;
  }

  //функция для вывода денежных средств из смарт-контракта 
  //выводится всё что есть на балансе и отправляется на адрес (_to)
  //может воспользоваться только владелец
  function withdrawTo(address payable _to) public requireOwner {
    _to.transfer(address(this).balance);
  }

  //вызывается автоматически, если в контракт придет некая сумма
  receive() external payable {
    if(currentTransfers >= maxTransfers) {
      revert("Cannot accept more transfers");
    }

    Transfer memory newTransfer = Transfer(msg.value, block.timestamp, msg.sender);
    
    transfers.push(newTransfer);
    currentTransfers++;
  }
}