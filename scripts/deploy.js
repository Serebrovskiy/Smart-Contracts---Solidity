const hre = require('hardhat')
const ethers = hre.ethers

async function main() {
  const [singer] = await ethers.getSigners()
  const Transfers = await ethers.getContractFactory('Transfers', singer)
  //отправляем транзакцию на развертывание, 3 - это макс кол-во транзакций
  const transfers = await Transfers.deploy(3)
  //дожидаемся пока транз-я будет выполнена
  await transfers.deployed()
  console.log(transfers.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });