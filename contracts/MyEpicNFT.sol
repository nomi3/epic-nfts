// MyEpicNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

  struct DotAttributes {
    string name;
    string dotSvg;
    string artistName;
  }

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  uint public constant PRICE = 0.01 ether;

  mapping(uint256 => DotAttributes) public nftHolderAttributes;
  mapping(address => uint256) public nftHolders;

  // string[] firstWords = ["YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  // function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {

  //   uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
	//   console.log("rand - seed: ", rand);
  //   rand = rand % firstWords.length;
	//   console.log("rand - first word: ", rand);
  //   return firstWords[rand];
  // }

  // function random(string memory input) internal pure returns (uint256) {
  //   return uint256(keccak256(abi.encodePacked(input)));
  // }

  constructor() ERC721 ("RandomDotNFT", "RDN") {
    console.log("This is my RandomDotNFT contract.");
  }

  function makeAnEpicNFT(string memory artist)public payable {
  // function makeAnEpicNFT(string memory artist)public payable {

    uint256 newItemId = _tokenIds.current();
    // require(msg.value >= PRICE, "Not enough ether to purchase NFTs.");

    string memory pixcelSvg = '<path fill="#000080" d="M140 100h20v20h-20z"/>';


    nftHolderAttributes[newItemId] = DotAttributes({
      name: "Growing Random Dot",
      dotSvg: pixcelSvg,
      artistName: artist
    });

    _safeMint(msg.sender, newItemId);

	  console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    _tokenIds.increment();

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function updateNFT() public {
    uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
    DotAttributes storage dot = nftHolderAttributes[nftTokenIdOfPlayer];

    dot.dotSvg = string(
      abi.encodePacked(
        dot.dotSvg,
        '<path fill="#ff1493" d="M120 100h20v20h-20z"/>'
      )
    );
  }

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    DotAttributes memory dotAttributes = nftHolderAttributes[_tokenId];

    string memory strName = dotAttributes.name;
    string memory strPixcelSvg = dotAttributes.dotSvg;
    string memory strArtistName = dotAttributes.artistName;

    string memory baseSvg = string(
      abi.encodePacked(
        '<svg baseProfile="full" viewBox="0 0 680 680" xmlns="http://www.w3.org/2000/svg"><style type="text/css">.st1{transform-origin:center;animation:w_mill 30s linear infinite;}@keyframes w_mill {to {transform:rotate(1turn);}}</style><g class="st1">',
        strPixcelSvg,
        '</g></svg>'
      )
    );

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            strName,
            '", "description": "We love random dot.", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(baseSvg)),
            '",',
            '"attributes":[{"trait_type":"Artist","value":"',
            strArtistName,
            '"},{"display_type":"date","trait_type":"',
            strArtistName,
            '","value":1664635807},{"display_type":"date","trait_type":"Artist2","value":1664645807}]}'
          )
        )
      )
    );

    string memory output = string(
      abi.encodePacked("data:application/json;base64,", json)
    );
    return output;
  }
}