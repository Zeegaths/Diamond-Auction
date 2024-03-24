pragma solidity ^0.8.0;

library LibAppStorage {
    uint256 constant TIME = 432000;
    
    struct Layout {
        //ERC20
        string name;
        string symbol;
        uint256 totalSupply;
        uint8 decimals;
        uint256 tokenId;
        string tokenURI;
        address[] allBids;
        uint256 currentPrice;
        uint256 biddingprice;
        uint256 auctionOpenTime;
        address diamondToken;
        


        mapping(address => uint256) ownerTokenCount;
        mapping(uint256 => mapping(address => uint256)) bidAmount;
        mapping(uint256 => address) NFTowner;
        mapping(uint256 => bool) isClosed;
        mapping(address => mapping(address => uint256)) allowances;
        mapping(address =>mapping(uint256 => bool))isOutBidded;
        mapping(address => mapping(address => bool)) _approved;
        mapping(uint256 => bool) tokenIdToApproved;
        // mapping(uint256 => address) ownerTokenCount;


        

       

        //AUCTION
    
        address NFT;      
        address[] bidders;
      
        mapping(uint256 =>mapping(address => uint256)) availableBids;
    } 

}