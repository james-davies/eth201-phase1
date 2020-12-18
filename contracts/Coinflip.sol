import "./Ownable.sol";
pragma solidity 0.5.12;

contract Coinflip is Ownable {

  mapping (address => uint) userBalance;

  modifier costMax(uint cost) {
    require(msg.value <= cost);
    _;
  }

  event flipResult(bool result, uint value);

  function maxCost()
  public
  view
  returns(uint)
  {
    // used division so there will always be money in the contract
    return address(this).balance / 4 ;
  }

  function withdraw()
  public
  payable
  {
    uint toTransfer = getUserBalance(msg.sender);
    userBalance[msg.sender] = 0;
    msg.sender.transfer(toTransfer);
  }

  function deposit()
  public
  payable
  {
    addUserFunds(msg.value, msg.sender);
  }

  function getUserBalance(address userAddress)
  public
  view
  returns(uint balance)
  {
    return userBalance[userAddress];
  }

  function random()
  private
  view
  returns(uint)
  {
    return now % 2;
  }

  function gamble(uint bet)
  public
  payable
  costMax(maxCost())
  returns (bool)
  {
    require(bet == 1 || bet == 0);
    uint res = random();
    bool result;
    if (res == bet) {
      result = true;
      addUserFunds(msg.value * 2, msg.sender);
      emit flipResult(result, res);
    } else {
      result = false;
      deductUserFunds(msg.value, msg.sender);
      emit flipResult(result, res);
    }

    return result;
  }

  function deductUserFunds(uint amount, address userAddress)
  private
  {
      userBalance[userAddress] -= amount;
  }

  function addUserFunds(uint amount, address userAddress)
  private
  {
      userBalance[userAddress] += amount;
  }

}
