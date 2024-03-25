// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "forge-std/Test.sol";
import "../contracts/Diamond.sol"; 
import "../contracts/facets/AuctionFacet.sol";
import "../contracts/ERC721Token.sol";
// import "../contracts/facets/ERC1155Facet.sol";
import "../contracts/facets/ERC20Facet.sol";

contract DiamondDeployer is Test, IDiamondCut {
    //contract types of facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    AuctionFacet AuctionF;   
    ERC20Facet Erc20F;
    ERC721Token Erc721T;

    //State variables

    address Owner = address(0xac);
    address NftOwner =address(0xdd);
    address A = address(0xaa);
    address B = address(0xbb);

    ERC20Facet boundERC20;
    AuctionFacet boundAuction;

    function setUp() public {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        AuctionF = new AuctionFacet();
        // Erc721F = new ERC721Facet();
        Erc20F = new ERC20Facet();
        Erc721T = new  ERC721Token();

     

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](4);

        cut[0] = (
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        cut[2] = (
            FacetCut({
                facetAddress: address(AuctionF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("AuctionFacet")
            })
        );


        cut[3] = (
            FacetCut({
                facetAddress: address(Erc20F),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("ERC20Facet")
            })
        );
        
        

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");

      
        Owner = mkaddr("owner");
        A = mkaddr("bidder a");
        B = mkaddr("bidder b");

        //mint test tokens
        ERC20Facet(address(diamond)).mintTo(Owner);
        // ERC20Facet(address(diamond)).mintTo(B);

        
        boundERC20 = ERC20Facet(address(diamond));
        boundAuction = AuctionFacet(address(diamond));
    }


    function testFailMintToFunction() public {
        uint256 bal = boundERC20.balanceOf(Owner);
        assertEq(bal, 100_000_00e18);
        // console.log(bal);
    }
    // function testForAuctionNftt() {}

    function testAuctionerIsOwner() public {

        switchSigner(NftOwner);
        Erc721T.mint();    
        Erc721T.approve(address(diamond), 1);

        vm.expectRevert("Only the owner can auction the NFT");

        switchSigner(Owner);
        boundAuction.auctionNFT(1, address(Erc721T));
       
    }
        

    function generateSelectors(
        string memory _facetName
    ) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }


    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    function switchSigner(address _newSigner) public {
        address foundrySigner = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
        if (msg.sender == foundrySigner) {
            vm.startPrank(_newSigner);
        } else {
            vm.stopPrank();
            vm.startPrank(_newSigner);
        }

        // uint256[]=new uint256[](2);
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}
}
