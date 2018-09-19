// -----------------------------------------------------------------------------------------
// Safe maths will help to protect against overflow or underflow attacks.
// unit256 can take a max value of 2^256-1, but it is possible to pass in a
// number that just 1 bigger than this maximum and cause a out of memory error.
// uint256 is susceptible to underflow attacks by pass in a negative value number as well.
// -----------------------------------------------------------------------------------------
// Based on OpenZeppelin project:
// Https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
// -----------------------------------------------------------------------------------------
pragma solidity ^0.4.23;

library SafeMath {

  // Multiplies two numbers, throws on overflow.
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  // Integer division of two numbers, truncating the quotient.
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  // Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  // Adds two numbers, throws on overflow.
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
  
  function percent(uint256 numerator, uint256 denominator, uint256 precision) internal pure returns(uint256) {
        uint256 _numerator  = numerator * 10 ** (precision + 1);
        return ((_numerator / denominator) + 5) / 10;
  }
}