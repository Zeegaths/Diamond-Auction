pragma solidity ^0.8.0;

library LibAppStorage {
    
    
    struct Bidder{
        address bidder;
        // uint256 tokenId;
        uint256 bidAmount;    
    }

    struct AuctionItem {
        address seller;
        uint256 biddingprice;
        bool isClosed;
       
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
        uint256 biddingprice;
        uint256 auctionOpenTime;

        mapping(uint256 => bool) isClosed;
        mapping(address => mapping(address => uint256)) allowances;
       

        //AUCTION
        address owner
        address rewardToken;
        address NFT;      
        address[] bidders;
      

        //NFTDetails
        mapping(uint256 =>mapping(address => uint256)) availableBids;
    }


    struct Nft {
        //ERC721
        Counters.Counter private _tokenIds;
        Counters.Counter private _itemsSold;
        mapping(uint256 => NFTOffer) public offers;
        mapping(address => uint256[]) public userTokens;       
        mapping(uint256 tokenId => address) private _owners;

        mapping(address owner => uint256) private _balances;

        mapping(uint256 tokenId => address) private _tokenApprovals;

        mapping(address owner => mapping(address operator => bool)) private _operatorApprovals; 
    }
        

   

}
