thisDir=$(dirname "$0")
walletDir=$thisDir/wallets/$BLOCKCHAIN_PREFIX

echo $1 - $(cat $walletDir/$1.addr)
cardano-cli query utxo --address $(cat $walletDir/$1.addr) $BLOCKCHAIN
