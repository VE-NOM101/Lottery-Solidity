// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery {
    address public owner;
    address payable[] public participants;
    address payable public  winner;
    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether, "You have to send exactly 1 Ether");
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == owner, "Only Owner can see the balance");
        return address(this).balance;
    }

    function random() public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.prevrandao,
                        msg.sender
                    )
                )
            );
    }

    function pickWinner() public returns(address){
        require(msg.sender == owner,"Only Owner can get winner");
        require(participants.length >= 3,"No of participants must be greater than 3.");
        uint r = random();
        uint i = r % participants.length;
        winner = participants[i];
        winner.transfer(getBalance());
        participants = new address payable [](0);
        return winner;
    }
}
