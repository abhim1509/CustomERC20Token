// ----------------------------------------------------------------------------
// 'Abhi' token contract
//

// Symbol      : Ab
// Name        : ERC20 Token
// Total supply: 100000000000000000000000000
// Decimals    : 18
//
// ----------------------------------------------------------------------------

pragma solidity ^0.6.4;
import "./ERC20Interface.sol";
import "./maths/SafeMath.sol";


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract ERC20 is ERC20Interface {
    using SafeMath for uint256;

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;

    string public name;
    string public decimals;
    string public symbol;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        string memory _decimalUnits,
        string memory  _tokenSymbol

    ) public {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account tokenOwner
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to to account
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public override returns (bool success) {
        require(balances[msg.sender] > tokens, "Insufficient balance.");
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], tokens);
        balances[to] = SafeMath.add(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer tokens from the from account to the to account
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
        uint256 allowance = allowed[from][to];
        require(
            balances[from] >= tokens &&
            allowance >= tokens,
            "Insufficient balance/allowance."
        );
        balances[from] = SafeMath.sub(balances[from], tokens);
        balances[to] = SafeMath.add(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for spender to transferFrom(...) tokens
    // from the token owner's account
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

}
