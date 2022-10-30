// deploy.js
const main = async () => {
  const contractAddress = "0x8A12dd8274e0B8F778D637640Df5C33591aeDd3C";
  const nftContract = await await hre.ethers.getContractAt("MyEpicNFT", contractAddress);

  let txn;
  // txn = await nftContract.makeAnEpicNFT("Super Artist",{
  //   value: hre.ethers.utils.parseEther("0.01"),
  // });


  txn = await nftContract.makeAnEpicNFT("Updated2 Artist", "f21080", 240, 180);
  await txn.wait();
  console.log("Minted NFT");

  // txn = await nftContract.updateNFT();
  // await txn.wait();
  // console.log("UPDATE NFT.");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
runMain();