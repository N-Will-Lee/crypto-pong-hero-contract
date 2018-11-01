pragma solidity ^0.4.19;


contract PingPongHero {

    struct User {
        address id;
        string userName;
        uint32 wins;
        uint32 losses;
    }

    User[] public users;

    mapping (uint => address) public userIdToAddress;

    function _createUser(address _walletAddress, string _userName) public {
        require(msg.sender == _walletAddress);
        uint id = users.push(User(_walletAddress, _userName, 0, 0));
        userIdToAddress[id] = _walletAddress;
    }
    
    struct Game {
        address creator;
        address opponent;
        address winner;
        uint8 op1Score;
        uint8 op2Score;
        uint256 wager;
        uint256 timeStamp;
        bool complete;
    }

    Game[] public gamesPlayed;

    mapping (uint => address) gameToPlayer;
    mapping (address => uint) opponentToUnconfirmedGame;

    
    
    // this needs to be a function that writes to the block
    function _finish(address _cr, address _opp, address _winner, uint8 _crScore, uint8 _oppScore, uint256 _wager, uint256 _time) public payable{
        require(msg.sender == _cr);
        if (_winner == _opp)    {
            require(msg.value == _wager*10**18);
        }
        uint id = gamesPlayed.push(Game(_cr, _opp, _winner, _crScore, _oppScore, _wager, _time, false));
        gameToPlayer[id] = _cr;
        gameToPlayer[id] = _opp;
        opponentToUnconfirmedGame[_opp] = id;
    }

    function _confirmGame(uint256 _gameId) public payable {
        require(msg.sender == gamesPlayed[_gameId].opponent);
        if (msg.sender == gamesPlayed[_gameId].winner)  {
            msg.sender.transfer(gamesPlayed[_gameId].wager);
        }
        if (msg.sender != gamesPlayed[_gameId].winner)  {
            require(msg.value == gamesPlayed[_gameId].wager);
            gamesPlayed[_gameId].creator.transfer(gamesPlayed[_gameId].wager);
        }
        gamesPlayed[_gameId].complete = true;
    }
}