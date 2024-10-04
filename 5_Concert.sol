//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./4_Ticket.sol";

contract Concert is Ownable{
    Ticket public ticket;
    uint public ticketPrice;
    uint public totalTickets;
    uint public ticketsSold;

    mapping(address => uint) public ticketTokenId;

    constructor(
        address _ticketsContractAddress,
        uint _ticketPrice,
        uint _totalTickets
    ){
        ticket = Ticket(_ticketsContractAddress);
        totalTickets = _totalTickets;
        ticketPrice = _ticketPrice;

        transferOwnership(msg.sender);
    }

    function purchaseTicket() public payable{
        require(ticketsSold < totalTickets, "Error: Housefull");
        require(ticketTokenId[msg.sender] == 0, "You already have a ticket");
        require(msg.value == ticketPrice, "Incorrect payment amount!");

        
        string memory uri = "https://www.shutterstock.com/image-vector/movie-ticket-template-admission-coupon-260nw-2173365817.jpg";
        ticket.safeMint(msg.sender, uri);
        uint tokenId = ticket.balanceOf(msg.sender);

        ticketTokenId[msg.sender] = tokenId;
        ticketsSold++;

    }

    function verifyTicket(address ticketHolder)
    public
    onlyOwner
    returns (bool)
    {
        require(ticketTokenId[ticketHolder] != 0, "This person is not allowed");
        require(ticket.balanceOf(ticketHolder)==1, "This person is not allowed");

        return true;
    }

    function withdrawFunds() public onlyOwner{
        payable(owner()).transfer(address(this).balance);
    }

    fallback() external payable { 
        revert("Please use purchase ticket function!");
    }

    receive() external payable { }
}