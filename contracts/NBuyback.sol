pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract DateTimeAPI {
  function isLeapYear(uint16 year) constant returns (bool);
  function getYear(uint timestamp) constant returns (uint16);
  function getMonth(uint timestamp) constant returns (uint8);
  function getDay(uint timestamp) constant returns (uint8);
  function getHour(uint timestamp) constant returns (uint8);
  function getMinute(uint timestamp) constant returns (uint8);
  function getSecond(uint timestamp) constant returns (uint8);
  function getWeekday(uint timestamp) constant returns (uint8);
  function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp);
  function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp);
  function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) constant returns (uint timestamp);
  function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp);
}

contract Token {
  function burnFrom(address _from, uint256 _value) public returns (bool);
}

/**
 * @title N Token Buy-back
 */
contract NBuyback {
  using SafeMath for uint256;

  address public owner;
  DateTimeAPI public datetime;
  Token public token;
  uint256 public rate;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor(address _owner, address _token, address _datetime, uint256 _rate) public {
    require(_token != address(0));
    require(_datetime != address(0));
    require(_owner != address(0));
    require(_rate > 0);

    owner = _owner;
    datetime = DateTimeAPI(_datetime);
    token = Token(_token);
    rate = _rate;
  }

  function buyBack(uint256 _amount) public {
    uint256 month = datetime.getMonth(block.timestamp);
    uint256 day = datetime.getDay(block.timestamp);

    require((month == 1 || month == 4 || month == 7 || month == 10) && day < 8);

    uint256 weiAmount = _amount.div(rate);

    assert(token.burnFrom(msg.sender, _amount));
    msg.sender.transfer(weiAmount);
  }

  function setRate(uint256 _rate) public onlyOwner {
    rate = _rate;
  }

  /**
    * @dev Throws if called by any account other than the owner.
    */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  function() external payable {}
}

/* TODO:
1. Set rates for buyback
2. Allow buyback according to rate
3. Refund tokens if no reserves
*/