//SDPX-Licence Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "./PriceConverter.sol";

contract FundMe{
    using PriceConverter for uint256;
    uint256 public minimumUSD = 50 * 1e18;
    address[] public funders;
    mapping (address=>uint256) public addressToAmountFunded;
    address public owner;
    constructor(){
    owner=msg.sender;
    }

    function fund() public payable{

        require(msg.value.getConversionRate() >= minimumUSD, "Doesn't have enough funds"); //1e18 = 1*10**18 = 1000000000000000000 WEI
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]+=msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint256 i=0;i<funders.length;i++){
            address funder=funders[i];
            addressToAmountFunded[funder]=0;
            funders=new address[](0);
        }
        (bool ret,) = payable(msg.sender).call{value:address(this).balance}("");
        require(ret,"failed!");
    }

    modifier onlyOwner{
        require(msg.sender==owner,"not the owner! withdrawal denied.");
        _;
    }
    receive() external payable{
        fund();

    }
    fallback() external payable{
        fund();
    }
    
}
