const hre = require('hardhat')
const ethers = hre.ethers
const TransfersArtifact = require('../artifacts/contracts/Transfers.sol/Transfers.json')

async function currentBalance(address, msg = '') {
  const rawBalance =  await ethers.provider.getBalance(address)
  console.log(msg, ethers.utils.formatEther(rawBalance))
}

async function main() {
  const [acc1, acc2] = await ethers.getSigners()
  const contractAddr = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512'
  //получаем объект контракта, с помощью которого сможем вызывать функции
  const transfersContract = new ethers.Contract(
    contractAddr,
    TransfersArtifact.abi,
    acc1
  )

  // const tx = {
  //   to: contractAddr,
  //   value: ethers.utils.parseEther('1')
  // }
  
  // //переводим 1eth с одного кашелька на другой
  // const txSend = await acc2.sendTransaction(tx)
  // await txSend.wait()
  
  // const result = await transfersContract.getTransfer(0)
  // console.log(ethers.utils.formatEther(result['amount']), result['sender'])

  //вызываем функцию вывода денежных средств относительно другого акк-та т.е не владельца
  // const result = await transfersContract.connect(acc2).withdrawTo(acc2.address)

  //вызываем функцию вывода денежных средств владельцем
  const result = await transfersContract.withdrawTo(acc2.address)
  console.log(result)
  await currentBalance(acc2.address, 'Account 2 balance:')
  await currentBalance(contractAddr, 'Contract balance:')
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });