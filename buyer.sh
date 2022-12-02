set -eu
thisDir=$(dirname "$0")
tempDir=$thisDir/temp
walletDir=$thisDir/wallets/$BLOCKCHAIN_PREFIX

# get walletaddress from seller
buyerwalletaddress=$(cat $walletDir/buyer.addr) 
echo "Buyerwalletaddress UTXO" $buyerwalletaddress

./QueryUtxo.sh $buyerwalletaddress
