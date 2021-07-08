pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract TokenSparse is ERC1155{
	address admin;
	
	mapping(uint=>uint) public tokensLeft; // id of token => max of a token available

	mapping(uint=>uint) public tokenPrice;

	constructor () ERC1155("http://tbd"){
		admin = msg.sender;
	}

	modifier IsAdmin{
		require(msg.sender == admin);
		_;
	}

	//This is update, NOT add to existing
	function UpdateNumToBeMinted(uint tokenId, uint num) public IsAdmin{
		uint moreTokensRequired = num - tokensLeft[tokenId] ;
		if (moreTokensRequired > 0) {
			mintNewToken(tokenId, moreTokensRequired);
		}
		tokensLeft[tokenId] = num;
	}

	function UpdateTokenPrice(uint tokenId, uint priceInWei) public IsAdmin{
		tokenPrice[tokenId] = priceInWei;
	}

	function SellToken(uint tokenId, uint num) public payable{
		require(msg.value >= tokenPrice[tokenId]);
		require(num > 0);
		require(tokensLeft[tokenId] >= num);
		safeTransferFrom(admin, msg.sender, tokenId, num, "0x0");
		tokensLeft[tokenId] -= num;
	}

	function mintNewToken(uint tokenId, uint num) public IsAdmin{
		_mint(admin, tokenId, num, "");
	}
}