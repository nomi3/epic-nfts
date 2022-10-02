// MyEpicNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

  using Counters for Counters.Counter;

  // _tokenIdsを初期化（_tokenIds = 0）
  Counters.Counter private _tokenIds;
  uint public constant PRICE = 0.01 ether;

  string baseSvg = '<svg baseProfile="full" viewBox="0 0 480 480" xmlns="http://www.w3.org/2000/svg"><path fill="#4DD706" d="M40 0h20v20H40z"/><path fill="#7736F3" d="M60 0h20v20H60z"/><path fill="#C5B70C" d="M200 0h20v20h-20z"/><path fill="#5EEE19" d="M380 0h20v20h-20z"/><path fill="#EAE281" d="M0 20h20v20H0z"/><path fill="#8219FD" d="M80 20h20v20H80z"/><path fill="#94EFC3" d="M120 20h20v20h-20z"/><path fill="#F8D685" d="M0 40h20v20H0z"/><path fill="#482B9D" d="M60 40h20v20H60z"/><path fill="#802A5A" d="M160 40h20v20h-20z"/><path fill="#3B0783" d="M180 40h20v20h-20z"/><path fill="#FFFDD7" d="M220 40h20v20h-20z"/><path fill="#B84454" d="M360 40h20v20h-20z"/><path fill="#28CA87" d="M180 60h20v20h-20z"/><path fill="#85435E" d="M280 60h20v20h-20z"/><path fill="#33B35F" d="M320 60h20v20h-20z"/><path fill="#9607A8" d="M340 60h20v20h-20z"/><path fill="#439A4A" d="M460 60h20v20h-20z"/><path fill="#6EFE8D" d="M0 80h20v20H0z"/><path fill="#790DA2" d="M20 80h20v20H20z"/><path fill="#CEEDCA" d="M40 80h20v20H40z"/><path fill="#549755" d="M60 100h20v20H60z"/><path fill="#8C301F" d="M460 100h20v20h-20z"/><path fill="#8DE03A" d="M40 120h20v20H40z"/><path fill="#4822EA" d="M440 120h20v20h-20z"/><path fill="#D6C0FC" d="M40 140h20v20H40z"/><path fill="#45F736" d="M80 140h20v20H80z"/><path fill="#30F43A" d="M240 140h20v20h-20z"/><path fill="#C1C5C6" d="M260 140h20v20h-20z"/><path fill="#606035" d="M80 160h20v20H80z"/><path fill="#759248" d="M180 160h20v20h-20z"/><path fill="#9A7B66" d="M220 160h20v20h-20z"/><path fill="#513A92" d="M260 160h20v20h-20z"/><path fill="#337D66" d="M340 160h20v20h-20z"/><path fill="#40E78B" d="M80 180h20v20H80z"/><path fill="#A5E947" d="M360 180h20v20h-20z"/><path fill="#3AB572" d="M20 200h20v20H20z"/><path fill="#6664DC" d="M160 200h20v20h-20z"/><path fill="#C5C7D9" d="M320 200h20v20h-20z"/><path fill="#1D5F20" d="M360 200h20v20h-20z"/><path fill="#6E37A6" d="M420 200h20v20h-20z"/><path fill="#C1800C" d="M260 240h20v20h-20z"/><path fill="#1BC422" d="M320 240h20v20h-20z"/><path fill="#C285E9" d="M60 260h20v20H60z"/><path fill="#4F50C7" d="M80 260h20v20H80z"/><path fill="#0F65BE" d="M100 260h20v20h-20z"/><path fill="#AFB725" d="M200 260h20v20h-20z"/><path fill="#984188" d="M220 260h20v20h-20z"/><path fill="#BC5394" d="M240 260h20v20h-20z"/><path fill="#9A68A2" d="M260 260h20v20h-20z"/><path fill="#5BF5AE" d="M340 260h20v20h-20z"/><path fill="#EFBFBF" d="M180 280h20v20h-20z"/><path fill="#18D063" d="M220 280h20v20h-20z"/><path fill="#48766E" d="M240 280h20v20h-20z"/><path fill="#2734FE" d="M360 280h20v20h-20z"/><path fill="#57504E" d="M400 280h20v20h-20z"/><path fill="#C8C1C8" d="M440 280h20v20h-20z"/><path fill="#802F9B" d="M40 320h20v20H40z"/><path fill="#9141DB" d="M60 320h20v20H60z"/><path fill="#B41CB7" d="M140 320h20v20h-20z"/><path fill="#03EEDE" d="M420 320h20v20h-20z"/><path fill="#662C17" d="M440 320h20v20h-20z"/><path fill="#0C91C4" d="M40 340h20v20H40z"/><path fill="#EB7F46" d="M80 340h20v20H80z"/><path fill="#28B2F9" d="M0 360h20v20H0z"/><path fill="#0C3C65" d="M200 360h20v20h-20z"/><path fill="#5327F5" d="M400 360h20v20h-20z"/><path fill="#DF039C" d="M440 360h20v20h-20z"/><path fill="#19BA70" d="M40 380h20v20H40z"/><path fill="#805D46" d="M140 380h20v20h-20z"/><path fill="#A11E42" d="M160 380h20v20h-20z"/><path fill="#E574CC" d="M200 380h20v20h-20z"/><path fill="#333419" d="M300 380h20v20h-20z"/><path fill="#EC2DA5" d="M0 400h20v20H0z"/><path fill="#E8110A" d="M60 400h20v20H60z"/><path fill="#BC8B7D" d="M100 400h20v20h-20z"/><path fill="#07D75B" d="M200 400h20v20h-20z"/><path fill="#00B264" d="M220 400h20v20h-20z"/><path fill="#624425" d="M260 400h20v20h-20z"/><path fill="#2B9E72" d="M400 400h20v20h-20z"/><path fill="#BF22DA" d="M60 420h20v20H60z"/><path fill="#33AF04" d="M100 420h20v20h-20z"/><path fill="#113FAE" d="M180 420h20v20h-20z"/><path fill="#3E3122" d="M280 420h20v20h-20z"/><path fill="#DFA1D0" d="M340 420h20v20h-20z"/><path fill="#284F9A" d="M400 420h20v20h-20z"/><path fill="#A381C0" d="M40 440h20v20H40z"/><path fill="#D98544" d="M80 440h20v20H80z"/><path fill="#702EA9" d="M120 440h20v20h-20z"/><path fill="#02D5B6" d="M160 440h20v20h-20z"/><path fill="#B49058" d="M220 440h20v20h-20z"/><path fill="#380E9D" d="M180 460h20v20h-20z"/><path fill="#D8BA7D" d="M220 460h20v20h-20z"/></svg>';

  string[] firstWords = ["YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD"];
  string[] secondWords = ["YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD"];
  string[] thirdWords = ["YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD"];


  // pickRandomFirstWord関数は、最初の単語を選びます。
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // pickRandomFirstWord 関数のシードとなる rand を作成します。
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // seed rand をターミナルに出力する。
	  console.log("rand - seed: ", rand);
	  // firstWords配列の長さを基準に、rand 番目の単語を選びます。
    rand = rand % firstWords.length;
	  // firstWords配列から何番目の単語が選ばれるかターミナルに出力する。
	  console.log("rand - first word: ", rand);
    return firstWords[rand];
  }

  // pickRandomSecondWord関数は、2番目に表示されるの単語を選びます。
  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    // pickRandomSecondWord 関数のシードとなる rand を作成します。
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  // pickRandomThirdWord関数は、3番目に表示されるの単語を選びます。
  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    // pickRandomThirdWord 関数のシードとなる rand を作成します。
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  // NFT トークンの名前とそのシンボルを渡します。
  constructor() ERC721 ("RandomDotNFT", "RDN") {
    console.log("This is my RandomDotNFT contract.");
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  // ユーザーが NFT を取得するために実行する関数です。
  function makeAnEpicNFT() public payable {
    // 現在のtokenIdを取得します。tokenIdは0から始まります。
    uint256 newItemId = _tokenIds.current();
    require(msg.value >= PRICE, "Not enough ether to purchase NFTs.");

    // // 3つの配列からそれぞれ1つの単語をランダムに取り出します。
    // string memory first = pickRandomFirstWord(newItemId);
    // string memory second = pickRandomSecondWord(newItemId);
    // string memory third = pickRandomThirdWord(newItemId);

	  // // 3つの単語を連携して格納する変数 combinedWord を定義します。
    // string memory combinedWord = string(abi.encodePacked(first, second, third));

    // // 3つの単語を連結して、<text>タグと<svg>タグで閉じます。
    // string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

	  // NFTに出力されるテキストをターミナルに出力します。
	  console.log("\n----- SVG data -----");
    console.log(baseSvg);
    console.log("--------------------\n");

    // JSONファイルを所定の位置に取得し、base64としてエンコードします。
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            // NFTのタイトルを生成される言葉（例: GrandCuteBird）に設定します。
            'RandomDot',
            '", "description": "We love random dot.", "image": "data:image/svg+xml;base64,',
            //  data:image/svg+xml;base64 を追加し、SVG を base64 でエンコードした結果を追加します。
            Base64.encode(bytes(baseSvg)),
            '",',
            '"attributes":[{"trait_type":"Player","value":"XXXXXX"},{"display_type":"date","trait_type":"Drawn Day1","value":1664635807},{"display_type":"date","trait_type":"Drawn Day2","value":1664645807}]}'
          )
        )
      )
    );

    // データの先頭に data:application/json;base64 を追加します。
    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

	  console.log("\n----- Token URI ----");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    // msg.sender を使って NFT を送信者に Mint します。
    _safeMint(msg.sender, newItemId);

    // tokenURIを更新します。
    _setTokenURI(newItemId, finalTokenUri);

 	  // NFTがいつ誰に作成されたかを確認します。
	  console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // 次の NFT が Mint されるときのカウンターをインクリメントする。
    _tokenIds.increment();
  }
}