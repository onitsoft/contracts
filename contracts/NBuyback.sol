pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract DateTimeAPI {
  function getMonth(uint timestamp) constant returns (uint8);
  function getDay(uint timestamp) constant returns (uint8);
}

contract Token {
  function burnFrom(address _from, uint256 _value) public returns (bool);
  function foo() public;
  function transfer(address _to, uint256 _value) public returns (bool);
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
  event BuyBack(address indexed sender, uint256 tokens, uint256 rate);

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

  function buyBack(uint256 _tokens) public {
    uint256 month = datetime.getMonth(block.timestamp);
    uint256 day = datetime.getDay(block.timestamp);
    uint256 returnToSender = 0;

    require((month == 1 || month == 4 || month == 7 || month == 10) && day < 8);

    uint256 weiAmount = _tokens.div(rate);

    if (weiAmount > address(this).balance) {
      returnToSender = weiAmount - address(this).balance;
      weiAmount = address(this).balance;
      _tokens = weiAmount.mul(rate);
    }

    token.burnFrom(msg.sender, _tokens);
    msg.sender.transfer(weiAmount);
    emit BuyBack(msg.sender, _tokens, rate);

    // Return tokens that are over ETH balance limit
    if (returnToSender > 0) {
     token.transfer(msg.sender, returnToSender);
    }
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

  function withdraw(address _to, uint _amount) public onlyOwner {
    _to.transfer(_amount);
  }

  function() external payable {}
}
