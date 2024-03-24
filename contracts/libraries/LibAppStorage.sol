pragma solidity ^0.8.0;

library LibAppStorage {
    uint256 constant TIME = 432000;   
 
    }

    struct Layout {
        //ERC20
        string name;
        string symbol;
        uint256 totalSupply;
        uint8 decimals;
        uint256 tokenId;
        string tokenURI;
        address[] availableBids
        uint256 currentPrice;
        uint256 biddingprice;block.timestamp - l.auctionOpenTime >= l.TIME
        uint256 auctionOpenTime;
        
        mapping(uint256 => address) NFTowner;
        mapping(uint256 => bool) isClosed;
        mapping(address => mapping(address => uint256)) allowances;
        mapping(address =>mapping(uint256 => bool))isOutBidded;
       

        //AUCTION
        address owner
        address rewardToken;
        address NFT;      
        address[] bidders;
      
        mapping(uint256 =>mapping(address => uint256)) availableBids;
    } 

}
