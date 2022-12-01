set -eu
thisDir=$(dirname "$0")
tempDir=$thisDir/temp
walletDir=$thisDir/wallets/$BLOCKCHAIN_PREFIX


smartcontractaddress=$(cat $tempDir/$BLOCKCHAIN_PREFIX/smartcontract.addr)
echo "Smartcontract address " $smartcontractaddress

cardano-cli query utxo \
$BLOCKCHAIN \
--address $smartcontractaddress