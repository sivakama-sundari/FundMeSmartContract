//SDPX-Licence Identifier: MIT
//get funding from users
//withdraw the funds
//set minimum value in USD


pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

function getPrice() internal view returns(uint256){
        AggregatorV3Interface price = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,)=price.latestRoundData();
        return uint256(answer * 1e10);
    }
    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice=getPrice();
        return (ethAmount*ethPrice)/1e18;
    }
}
