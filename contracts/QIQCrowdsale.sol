pragma solidity ^0.4.18;


library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function max64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}


contract ERC20Basic {
    uint256 public totalSupply;

    bool public transfersEnabled;

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}


contract ERC20 {
    uint256 public totalSupply;

    bool public transfersEnabled;

    function balanceOf(address _owner) public constant returns (uint256 balance);

    function transfer(address _to, uint256 _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping (address => uint256) balances;

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(transfersEnabled);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

}


contract StandardToken is ERC20, BasicToken {

    mapping (address => mapping (address => uint256)) internal allowed;


    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(transfersEnabled);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /**
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     */
    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        }
        else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnerChanged(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() public {
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
    function changeOwner(address newOwner) onlyOwner public {
        require(newOwner != address(0));
        OwnerChanged(owner, newOwner);
        owner = newOwner;
    }

}


/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */

contract MintableToken is StandardToken, Ownable {
    string public constant name = "Qtoken";

    string public constant symbol = "QIQ";

    uint8 public constant decimals = 18;

    event Mint(address indexed to, uint256 amount);

    event MintFinished();

    bool public mintingFinished;

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
        balances[_to] = balances[_to].add(_amount);
        balances[_owner] = balances[_owner].sub(_amount);
        Mint(_to, _amount);
        Transfer(_owner, _to, _amount);
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishMinting() onlyOwner canMint internal returns (bool) {
        mintingFinished = true;
        MintFinished();
        return true;
    }

}


/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale is Ownable {
    using SafeMath for uint256;

    // start and end timestamps where investments are allowed (both inclusive)
    uint256 public startTimePreICO;

    uint256 public endTimePreICO;

    uint256 public startTime1stICO;

    uint256 public endTime1stICO;

    uint256 public startTime2ndICO;

    uint256 public endTime2ndICO;

    uint256 public startTimeFinalICO;

    uint256 public endTimeFinalICO;

    // address where funds are collected
    address public wallet;

    // amount of raised money in wei
    uint256 public weiRaised;

    uint256 public tokenAllocated;

    uint256 public hardWeiCap = 10 * (10 ** 3) * (10 ** 18);

    function Crowdsale(
    uint256 _startTimePreICO,
    uint256 _endTimePreICO,
    uint256 _startTime1stICO,
    uint256 _endTime1stICO,
    uint256 _startTime2ndICO,
    uint256 _endTime2ndICO,
    uint256 _startTimeFinalICO,
    uint256 _endTimeFinalICO,
    address _wallet
    )
    public
    {
        require(_startTimePreICO >= now);
        require(_endTimePreICO > _startTimePreICO && _startTime1stICO > _endTimePreICO);
        require(_endTime1stICO > _startTime1stICO && _startTime2ndICO > _endTime1stICO);
        require(_endTimeFinalICO > _startTimeFinalICO);
        require(_wallet != address(0));

        startTimePreICO = _startTimePreICO;
        endTimePreICO = _endTimePreICO;
        startTime1stICO = _startTime1stICO;
        endTime1stICO = _endTime1stICO;
        startTime2ndICO = _startTime2ndICO;
        endTime2ndICO = _endTime2ndICO;
        startTimeFinalICO = _startTimeFinalICO;
        endTimeFinalICO = _endTimeFinalICO;

        wallet = _wallet;
    }
}


contract QIQCrowdsale is Ownable, Crowdsale, MintableToken {
    using SafeMath for uint256;

    enum State {Active, Closed}
    State public state;

    mapping (address => uint256) public deposited;

    uint256 public constant INITIAL_SUPPLY = 80 * (10 ** 6) * (10 ** uint256(decimals));

    uint256 public fundForSale = 20 * (10 ** 6) * (10 ** uint256(decimals));

    uint256 public tokenPreIcoCapReached = 5 * (10 ** 6) * (10 ** uint256(decimals));

    uint256 public weiMinPreIco = 5 * 10 ** 17;

    uint256 public weiMinIco = 1 * 10 ** 17;

    uint256 public weiMaximum = 50 * 10 ** 18;

    uint256 public countInvestor;

    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);

    event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);

    event HardCapReached();

    event Finalized();


    function QIQCrowdsale(
    uint256 _startTimePreICO,
    uint256 _endTimePreICO,
    uint256 _startTime1stICO,
    uint256 _endTime1stICO,
    uint256 _startTime2ndICO,
    uint256 _endTime2ndICO,
    uint256 _startTimeFinalICO,
    uint256 _endTimeFinalICO,
    address _owner,
    address _wallet
    )
    public
    Crowdsale(_startTimePreICO, _endTimePreICO, _startTime1stICO, _endTime1stICO,
    _startTime2ndICO, _endTime2ndICO, _startTimeFinalICO, _endTimeFinalICO, _wallet)
    {

        require(_wallet != address(0));
        require(_owner != address(0));
        owner = _owner;
        transfersEnabled = true;
        mintingFinished = false;
        state = State.Active;
        totalSupply = INITIAL_SUPPLY;
        bool resultMintForOwner = mintForOwner(owner);
        require(resultMintForOwner);
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    // fallback function can be used to buy tokens
    function() payable public {
        buyTokens(msg.sender);
    }

    // low level token purchase function
    function buyTokens(address _investor) public inState(State.Active) payable returns (uint256){
        require(_investor != address(0));
        uint256 weiAmount = msg.value;
        require(weiAmount < weiMaximum);
        uint256 tokens = validPurchaseTokens(weiAmount);
        if (tokens == 0) {revert();}
        weiRaised = weiRaised.add(weiAmount);
        tokenAllocated = tokenAllocated.add(tokens);
        mint(_investor, tokens, owner);

        TokenPurchase(_investor, weiAmount, tokens);
        if (deposited[_investor] == 0) {
            countInvestor = countInvestor.add(1);
        }
        deposit(_investor);
        wallet.transfer(weiAmount);
        return tokens;
    }

    /**
    * Pre ICO              (10th Feb (UTC 8:00) to 18th Feb (UTC 8:00)) - 40% bonus [Min. purchase of 0.5 ETH]
    * Main ICO 1st round   (18th Feb (UTC 8:01) to 28th Feb (UTC 8:00)) - 25% bonus [Min. purchase of 0.1 ETH]
    * Main ICO 2nd round   (28th Feb (UTC 8:01) to 15th Mar (UTC 8:00)) - 15% bonus [Min. purchase of 0.1 ETH]
    * Main ICO Final round (15th Mar (UTC 8:01) to 30th Mar (UTC 8:00)) -  0% bonus [Min. purchase of 0.1 ETH]
    *
    * Only for Pre ICO stage with a cap of 5 million tokens for sale.
    */
    function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256 amountOfTokens) {
        uint256 currentTokenRate = 10;
        uint256 currentDate = now;
        //uint256 currentDate = 1521100821;
        require(currentDate >= startTimePreICO);
        if (currentDate >= startTimePreICO && currentDate < endTimePreICO) {
            if (_weiAmount < weiMinPreIco) {
                currentTokenRate = 0;
            }
            else {
                currentTokenRate = _weiAmount.mul(15 * 140);
            }
            if (tokenAllocated.add(currentTokenRate) > tokenPreIcoCapReached) {
                TokenLimitReached(tokenAllocated, currentTokenRate);
                currentTokenRate = 0;
            }
            return currentTokenRate;
        }

        if (_weiAmount < weiMinIco) {
            return 0;
        }
        else if (currentDate >= startTime1stICO && currentDate < endTime1stICO) {
            currentTokenRate = _weiAmount.mul(15 * 125);
        }
        else if (currentDate >= startTime2ndICO && currentDate < endTime2ndICO) {
            currentTokenRate = _weiAmount.mul(15 * 115);
        }
        else if (currentDate >= startTimeFinalICO && currentDate < endTimeFinalICO) {
            currentTokenRate = _weiAmount.mul(15 * 100);
        } else {
            currentTokenRate = 0;
        }
        return currentTokenRate;
    }

    function deposit(address investor) internal {
        require(state == State.Active);
        deposited[investor] = deposited[investor].add(msg.value);
    }

    function mintForOwner(address _wallet) internal returns (bool result) {
        result = false;
        require(_wallet != address(0));
        balances[_wallet] = balances[_wallet].add(INITIAL_SUPPLY);
        result = true;
    }

    function getDeposited(address _investor) public view returns (uint256){
        return deposited[_investor];
    }

    /**
    * Hard cap - 10,000 ETH
    * for token sale (20million)
    */
    function validPurchaseTokens(uint256 _weiAmount) public inState(State.Active) returns (uint256) {
        uint256 addTokens = getTotalAmountOfTokens(_weiAmount);
        if (tokenAllocated.add(addTokens) > fundForSale) {
            TokenLimitReached(tokenAllocated, addTokens);
            return 0;
        }
        if (weiRaised.add(_weiAmount) > hardWeiCap) {
            HardCapReached();
            return 0;
        }
        return addTokens;
    }

    function finalize() public onlyOwner inState(State.Active) returns (bool result) {
        result = false;
        state = State.Closed;
        wallet.transfer(this.balance);
        finishMinting();
        Finalized();
        result = true;
    }
}

