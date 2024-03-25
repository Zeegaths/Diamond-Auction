pragma solidity ^0.8.0;

library LibAppStorage {
    uint256 constant TIME = 432000;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
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
        mapping(address => uint256) balances;
        
        
        // mapping(uint256 => address) ownerTokenCount;      

        //AUCTION
    
        address NFT;      
        address[] bidders;
      
        mapping(uint256 =>mapping(address => uint256)) availableBids;
    } 


    function layoutStorage() internal pure returns (Layout storage l) {
        assembly {
            l.slot := 0
        }
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) internal {
        Layout storage l = layoutStorage();
        uint256 frombalances = l.balances[msg.sender];
        require(
            frombalances >= _amount,
            "ERC20: Not enough tokens to transfer"
        );
        l.balances[_from] = frombalances - _amount;
        l.balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
    }

}