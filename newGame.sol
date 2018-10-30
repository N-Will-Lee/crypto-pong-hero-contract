pragma solidity ^0.4.19;

import "./CreateUser.sol";

contract NewGame is CreateUser {
    
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
        require(msg.sender == _cr, "You're not the game host");
        if (_winner == _opp)    {
            require(msg.value == _wager, "Please send agreed upon wager amount");
        }
        uint id = gamesPlayed.push(Game(_cr, _opp, _winner, _crScore, _oppScore, _wager, _time, false));
        gameToPlayer[id] = _cr;
        gameToPlayer[id] = _opp;
        opponentToUnconfirmedGame[_opp] = id;
    }

    function _confirmGame(uint256 _gameId) public payable {
        require(msg.sender == gamesPlayed[_gameId].opponent, "Match can only be confirmed by opponent");
        if (msg.sender == gamesPlayed[_gameId].winner)  {
            msg.sender.transfer(gamesPlayed[_gameId].wager);
        }
        if (msg.sender != gamesPlayed[_gameId].winner)  (
            require(msg.value == gamesPlayed[_gameId].wager, "must send the agreed upon wager amount");
            gamesPlayed[_gameId].creater.transfer(gamesPlayed[_gameId].wager);
        )
    }
    
}