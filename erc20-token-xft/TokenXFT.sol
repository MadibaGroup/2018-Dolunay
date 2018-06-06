// -----------------------------------------------------------------------------------------
// Compilation of:
// 1- Https://theethereum.wiki/w/index.php/ERC20_Token_Standard
// 2- Https://www.ethereum.org/token
// -----------------------------------------------------------------------------------------
// In order to work with tokens, we will need to install a chrome extention called MetaMask.
// It is a Ethereum wallet that runs within chrome browser and allows us to interact with
// Ethereum DApp by injecting a Javascript library called Web3 into the browser.
// By doing that any Ethereum connected web application will use that library to talk to
// Ethereum network.
// -----------------------------------------------------------------------------------------
pragma solidity ^0.4.23;

import './ERC20_Interface.sol';
import './SafeMath.sol';

contract TokenXFT is ERC20Interface{
    using SafeMath for uint256;
 
    string public constant name = "Future Events";
    string public constant symbol = "XFT";
    uint8 public constant decimals = 18;                        // 1 XFT can be broken down up to 16 decimal places (like ETH)
    
    uint256 public exchangeRate = 1000;                         // 1000 XFT will be equal to 1 ETH as initial exchange rate.

    mapping(address => uint256) balances;                       // Balances for each account
    mapping(address => mapping (address => uint256)) allowed;   // Owner of account approves the transfer of an amount to another account
    
    address private owner = 0x0;
    uint256 private _initialSupply = 1000000;
    uint256 private _totalSupply;
    bool private acceptingETH = true;                           // Controls possiblity of sending ETH to the contract
    bool public isRunning = true;                                 // Stops the token contract
    
    constructor() public {
        owner = msg.sender;
        _totalSupply = _initialSupply * 10 ** uint256(decimals);// Update total supply with the decimal amount
        balances[owner] = _totalSupply;
        emit Transfer(0x0, owner, _totalSupply);
    }
    
    // -----------------------------------------------------------------------------
    // Allows people to send ETH directly to the token contract address and
    // buy XFT based on exchange rate (i.e, sending 1ETH will give them 1000XFT)
    // -----------------------------------------------------------------------------
    function () isAcceptingETH payable public{
        require(msg.value > 0);
        exchangeToken();
    }
    
    // -----------------------------------------------------------------------------
    // Allows people to send ETH and buy XFT based on exchange rate
    // -----------------------------------------------------------------------------
    function exchangeToken() isAcceptingETH payable public{
        uint256 numTokens = msg.value.mul(exchangeRate);
        buyToken(numTokens);
    }
    
    // -----------------------------------------------------------------------------
    // Allows people to buy exact number of token
    // -----------------------------------------------------------------------------
    function buyToken(uint256 _numTokens) isAcceptingETH payable public{
        assert(isRunning);
        uint256 _value = _numTokens.div(exchangeRate);
        require(msg.value >= _value);
        require(balances[owner] >= _numTokens);
        balances[msg.sender] = balances[msg.sender].add(_numTokens);
        balances[owner] = balances[owner].sub(_numTokens);
        
        // Transfering ETH sent to the contract to the owner of the contract
        // If it was not successful, it will revert everything back
        owner.transfer(_value);
    }

    // -----------------------------------------------------------------------------
    // Returns total amount of token in circulation
    // -----------------------------------------------------------------------------
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    // -----------------------------------------------------------------------------
    // Get the token balance for an address
    // -----------------------------------------------------------------------------
    function balanceOf(address _tokenOwner) public view returns (uint256 tokens) {
        return balances[_tokenOwner];
    }
 
    // -----------------------------------------------------------------------------
    // Transfer the balance (value) from owner's account to another account
    // -----------------------------------------------------------------------------
    function transfer(address _to, uint256 _tokens) public returns (bool success) {
        assert(isRunning);
        require(_tokens > 0);                                       // Check for more than zero token
        require(balances[msg.sender] >= _tokens);                   // Check if the sender has enough
        require(balances[_to] + _tokens >= balances[_to]);          // Check for overflows
        balances[msg.sender] = balances[msg.sender].sub(_tokens);   // Subtract from the sender
        balances[_to] = balances[_to].add(_tokens);                 // Add the same to the recipient
        emit Transfer(msg.sender, _to, _tokens);
        return true;
    }
 
    // -----------------------------------------------------------------------------
    // Special type of Transfer and make it possible to give permission to another address 
    // to spend token on your behalf.
    // It sends _tokens amount of tokens from address _from to address _to
    // The transferFrom method is used for a withdraw workflow, allowing contracts to send
    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
    // fees in sub-currencies; the command should fail unless the _from account has
    // deliberately authorized the sender of the message via some mechanism
    // -----------------------------------------------------------------------------
    function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool success) {
        assert(isRunning);
        require( _tokens > 0);                                      // Check allowance
        require(allowed[_from][msg.sender] >= _tokens);
        require(balances[_from] >= _tokens);
        balances[_from] = balances[_from].sub(_tokens);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_tokens);
        balances[_to] = balances[_to].add(_tokens);
        emit Transfer(_from, _to, _tokens);
        return true;
    }

    // -----------------------------------------------------------------------------    
    // It helps to give permission to another address to spend tokens on your behalf.
    // Allow _spender to withdraw from your account, multiple times, up to the _tokens amount.
    // If this function is called again it overwrites the current allowance with _tokens.
    // -----------------------------------------------------------------------------
    function approve(address _spender, uint256 _tokens) public returns (bool success) {
        assert(isRunning);
        allowed[msg.sender][_spender] = _tokens;
        emit Approval(msg.sender, _spender, _tokens);
        return true;
    }
    
    // -----------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account. In other word, how many tokens we gave
    // permission to another address to spend
    // -----------------------------------------------------------------------------
    function allowance(address _tokenOwner, address _spender) public view returns (uint256 remaining) {
        assert(isRunning);
        return allowed[_tokenOwner][_spender];
    }
    
    // -----------------------------------------------------------------------------
    // Allows owner to add more supply
    // -----------------------------------------------------------------------------
    function mintToken(uint256 _mintedTokens) onlyOwner public {
        balances[owner] = balances[owner].add(_mintedTokens);
        _totalSupply = _totalSupply.add(_mintedTokens);
        emit Transfer(0x0, owner, _mintedTokens);
    }
    
    // -----------------------------------------------------------------------------
    // Makes tokens not spendable by sending them to 0x0 address
    // -----------------------------------------------------------------------------
    function burnToken(uint256 _tokens) public returns (bool success) {
        require(balances[msg.sender] >= _tokens);                   // Check if the sender has enough token
        balances[msg.sender] = balances[msg.sender].sub(_tokens);   // Subtract from the sender
        _totalSupply = _totalSupply.sub(_tokens);                   // Updates totalSupply
        emit Burn(msg.sender, _tokens);
        return true;
    }
    
    function burnTokenFrom(address _address, uint256 _tokens) public returns (bool success) {
        require(balances[_address] >= _tokens);                                         // Check if the targeted balance is enough
        require(_tokens <= allowed[_address][msg.sender]);                              // Check allowance
        balances[_address] = balances[_address].sub(_tokens);                           // Subtract from the targeted balance
        allowed[_address][msg.sender] = allowed[_address][msg.sender].sub(_tokens);     // Subtract from the sender's allowance
        _totalSupply = _totalSupply.sub(_tokens);                                       // Update totalSupply
        emit Burn(_address, _tokens);
        return true;
    }
    
    function setRate(uint256 _rate) onlyOwner public {
        exchangeRate = _rate;
        emit RateUpdated(_rate);
    }
    
    function setAcceptingETH(bool _acceptingETH) onlyOwner public {
        acceptingETH = _acceptingETH;
    }
    
    function setRunning(bool _isRunning) onlyOwner public {
        isRunning = _isRunning;
    }

    modifier onlyOwner {
        assert(owner == msg.sender);
        _;
    }
    
    modifier isAcceptingETH {
        assert (acceptingETH);
        _;
    }
    
    modifier isValidAddress {
        assert (msg.sender != 0x0);
        _;
    }

    event RateUpdated(uint256 _newRate);
    event Burn(address indexed from, uint256 value);
}