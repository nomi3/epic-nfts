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

  string baseSvg = '<svg baseProfile="full" viewBox="0 0 680 680" xmlns="http://www.w3.org/2000/svg"><style type="text/css">.st1{transform-origin:center;animation:w_mill 30s linear infinite;}@keyframes w_mill {to {transform:rotate(1turn);}}</style><g class="st1"><path fill="#9A8C3A" d="M140 100h20v20h-20z"/><path fill="#BF18DA" d="M260 100h20v20h-20z"/><path fill="#808C88" d="M480 100h20v20h-20z"/><path fill="#2BBD67" d="M540 100h20v20h-20z"/><path fill="#7D8849" d="M100 120h20v20h-20z"/><path fill="#C0438E" d="M240 120h20v20h-20z"/><path fill="#CEF12A" d="M360 120h20v20h-20z"/><path fill="#6FC500" d="M460 120h20v20h-20z"/><path fill="#63FBDE" d="M540 120h20v20h-20z"/><path fill="#524554" d="M120 140h20v20h-20z"/><path fill="#DE50B9" d="M140 140h20v20h-20z"/><path fill="#DC78E2" d="M460 140h20v20h-20z"/><path fill="#CBA55F" d="M500 140h20v20h-20z"/><path fill="#FA4D46" d="M300 160h20v20h-20z"/><path fill="#8E3D81" d="M360 160h20v20h-20z"/><path fill="#877C2A" d="M380 160h20v20h-20z"/><path fill="#AA7B63" d="M400 160h20v20h-20z"/><path fill="#285DAB" d="M440 160h20v20h-20z"/><path fill="#9B3C00" d="M460 160h20v20h-20z"/><path fill="#A51ACF" d="M500 160h20v20h-20z"/><path fill="#FBD6B2" d="M160 180h20v20h-20z"/><path fill="#882BEB" d="M260 180h20v20h-20z"/><path fill="#225D3A" d="M380 180h20v20h-20z"/><path fill="#CD2A54" d="M440 180h20v20h-20z"/><path fill="#098CB5" d="M180 200h20v20h-20z"/><path fill="#1D135D" d="M340 200h20v20h-20z"/><path fill="#2FAF8A" d="M400 200h20v20h-20z"/><path fill="#BD4082" d="M440 200h20v20h-20z"/><path fill="#3E7795" d="M480 200h20v20h-20z"/><path fill="#AA79DC" d="M560 200h20v20h-20z"/><path fill="#361E2B" d="M140 220h20v20h-20z"/><path fill="#681B39" d="M440 220h20v20h-20z"/><path fill="#9090BA" d="M520 220h20v20h-20z"/><path fill="#65063E" d="M220 240h20v20h-20z"/><path fill="#AD90D8" d="M260 240h20v20h-20z"/><path fill="#28FE65" d="M460 240h20v20h-20z"/><path fill="#B33DD5" d="M500 240h20v20h-20z"/><path fill="#DF5B41" d="M160 260h20v20h-20z"/><path fill="#B73FEE" d="M420 260h20v20h-20z"/><path fill="#B40BEF" d="M500 260h20v20h-20z"/><path fill="#A21FE3" d="M140 280h20v20h-20z"/><path fill="#2E54FF" d="M220 280h20v20h-20z"/><path fill="#CF9756" d="M240 280h20v20h-20z"/><path fill="#8C21AD" d="M420 280h20v20h-20z"/><path fill="#BEA8C7" d="M440 300h20v20h-20z"/><path fill="#BCDA68" d="M480 300h20v20h-20z"/><path fill="#C3A2F0" d="M240 320h20v20h-20z"/><path fill="#CC2CC0" d="M280 320h20v20h-20z"/><path fill="#35F8AB" d="M320 320h20v20h-20z"/><path fill="#F5BAB6" d="M360 320h20v20h-20z"/><path fill="#6F6E18" d="M380 320h20v20h-20z"/><path fill="#41BE05" d="M480 320h20v20h-20z"/><path fill="#A5F8AE" d="M140 340h20v20h-20z"/><path fill="#B6743D" d="M480 340h20v20h-20z"/><path fill="#A52BA0" d="M120 360h20v20h-20z"/><path fill="#14D355" d="M400 360h20v20h-20z"/><path fill="#E13750" d="M500 360h20v20h-20z"/><path fill="#E2D8C3" d="M360 380h20v20h-20z"/><path fill="#A2EBBC" d="M460 380h20v20h-20z"/><path fill="#E3638D" d="M480 380h20v20h-20z"/><path fill="#023D36" d="M540 380h20v20h-20z"/><path fill="#F91174" d="M160 400h20v20h-20z"/><path fill="#1EA8E6" d="M340 400h20v20h-20z"/><path fill="#B99021" d="M440 400h20v20h-20z"/><path fill="#BD4969" d="M100 420h20v20h-20z"/><path fill="#379EB5" d="M420 420h20v20h-20z"/><path fill="#46331C" d="M500 420h20v20h-20z"/><path fill="#406CE0" d="M100 440h20v20h-20z"/><path fill="#F35B4F" d="M460 440h20v20h-20z"/><path fill="#33BAC7" d="M540 440h20v20h-20z"/><path fill="#2ED15A" d="M560 440h20v20h-20z"/><path fill="#CDC985" d="M100 460h20v20h-20z"/><path fill="#1A673C" d="M180 460h20v20h-20z"/><path fill="#5C7103" d="M280 460h20v20h-20z"/><path fill="#0A2F11" d="M340 460h20v20h-20z"/><path fill="#213058" d="M180 480h20v20h-20z"/><path fill="#E6D75A" d="M200 480h20v20h-20z"/><path fill="#58B773" d="M220 480h20v20h-20z"/><path fill="#03CB09" d="M540 480h20v20h-20z"/><path fill="#549EC1" d="M200 500h20v20h-20z"/><path fill="#F1ED3C" d="M240 500h20v20h-20z"/><path fill="#952E2E" d="M280 500h20v20h-20z"/><path fill="#331829" d="M300 500h20v20h-20z"/><path fill="#F21BC8" d="M460 500h20v20h-20z"/><path fill="#053093" d="M200 520h20v20h-20z"/><path fill="#11D214" d="M540 520h20v20h-20z"/><path fill="#06AD9F" d="M240 540h20v20h-20z"/><path fill="#71C9EE" d="M400 540h20v20h-20z"/><path fill="#B68B60" d="M420 540h20v20h-20z"/><path fill="#558E4C" d="M440 540h20v20h-20z"/><path fill="#FFDB13" d="M560 540h20v20h-20z"/><path fill="#CAA726" d="M200 560h20v20h-20z"/><path fill="#CB7FC6" d="M300 560h20v20h-20z"/><path fill="#5CF737" d="M480 560h20v20h-20z"/><path fill="#BDC53C" d="M500 560h20v20h-20z"/></g></svg>';

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
  function makeAnEpicNFT(string memory artist) public payable {
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
            '"attributes":[{"trait_type":"Artist","value":"',
            artist,
            '"},{"display_type":"date","trait_type":"',
            artist,
            '","value":1664635807},{"display_type":"date","trait_type":"Artist2","value":1664645807}]}'
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