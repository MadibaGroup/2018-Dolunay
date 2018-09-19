pragma solidity ^0.4.21;

// -----------------------------------------------------------------------------
// ERC20: ERC Token Standard #20 Interface
// Https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// A dreaft specification that defines what a token smart contract should look like
// -----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint256);
    function balanceOf(address _tokenOwner) public view returns (uint256 tokens);
    function transfer(address _to, uint256 _tokens) public returns (bool success);
    function approve(address _spender, uint256 _tokens) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool success);
    function allowance(address _tokenOwner, address _spender) public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _tokens);
    event Approval(address indexed _tokenOwner, address indexed _spender, uint256 _tokens);
}