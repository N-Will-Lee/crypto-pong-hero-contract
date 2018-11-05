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

    mapping (uint => address) public gameToHomePlayer;
    mapping (uint => address) public gameToAwayPlayer;
    mapping (address => uint) public playerGameCount;

    
    function _finish(address _cr, address _opp, address _winner, uint8 _crScore, uint8 _oppScore, uint256 _wager, uint256 _time) public payable{
        require(msg.sender == _cr);
        if (_winner == _opp)    {
            require(msg.value == _wager);
            _opp.transfer(msg.value);
        }
        uint id = gamesPlayed.push(Game(_cr, _opp, _winner, _crScore, _oppScore, _wager, _time, false));
        gameToHomePlayer[id] = _cr;
        gameToAwayPlayer[id] = _opp;
        playerGameCount[_opp]++;
        playerGameCount[_cr]++;
    }

    function _getTotalGameNumber() external view returns(uint)  {
        uint total = 0;
        total = gamesPlayed.length;
        return total;
    }


    function _confirmGame(uint256 _gameId) public payable {
        require(gamesPlayed[_gameId].complete == false);
        address creator = gamesPlayed[_gameId].creator;
        address opponent = gamesPlayed[_gameId].opponent;
        address winner = gamesPlayed[_gameId].winner;
        uint256 wager = gamesPlayed[_gameId].wager;
        require(msg.sender == opponent);
        if (msg.sender != winner)  {
            require(msg.value == wager);
            creator.transfer(msg.value);
        }
        gamesPlayed[_gameId].complete = true;
    }
}