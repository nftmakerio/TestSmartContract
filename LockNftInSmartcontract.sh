set -eu
thisDir=$(dirname "$0")
tempDir=$thisDir/temp
walletDir=$thisDir/wallets/$BLOCKCHAIN_PREFIX

# get walletaddress from seller
sellerwalletaddress=$(cat $walletDir/seller.addr) 
echo "Sellerwalletaddress " $sellerwalletaddress

# what we put into the smartcontract - so which nft we want to sell
value="2000000 lovelace + 1 $POLICYID.$ASSETNAME" 

echo "Sell this: " $value

# save protocol parameters
echo "Save protocol parameters"
cardano-cli query protocol-parameters \
    $BLOCKCHAIN \
    --out-file $tempDir/$BLOCKCHAIN_PREFIX/protocol-parameters.json

# create the address for the smartcontract
echo "Create smartcontract address from plutus script"
cardano-cli address build \
  --payment-script-file ./plutus/buy.plutus \
  $BLOCKCHAIN \
  --out-file $tempDir/$BLOCKCHAIN_PREFIX/smartcontract.addr



# look for the txins
changeOutput=$(cardano-cli-balance-fixer change --address $sellerwalletaddress $BLOCKCHAIN -o "$value")
echo "ChangeOutput: " $changeOutput

# if there are more tokens, we put it into extraoutput
extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi
echo "ExtraOutput: " $extraOutput

# the smart contract address
smartcontractaddress=$(cat $tempDir/$BLOCKCHAIN_PREFIX/smartcontract.addr)
echo "Smartcontract address " $smartcontractaddress

# look for inputs
txins=$(cardano-cli-balance-fixer input --address $sellerwalletaddress $BLOCKCHAIN)
echo "Inputs: " $txins


cardano-cli query utxo \
$BLOCKCHAIN \
--address $sellerwalletaddress

# the datum hash
scriptDatumHash=$(cat $tempDir/$BLOCKCHAIN_PREFIX/datums/buy-hash.txt)

# the created raw file
bodyFile=$tempDir/lock.raw
outFile=$tempDir/lock-signed.raw
signingKey=$walletDir/seller.skey

# build the transaction
echo "Create Transaction"
set -eux
cardano-cli transaction build \
    --babbage-era \
    $BLOCKCHAIN \
    $txins \
    --tx-out "$smartcontractaddress + $value" \
    --tx-out-datum-hash $scriptDatumHash \
    --tx-out "$sellerwalletaddress + 2000000 lovelace $extraOutput" \
    --change-address $sellerwalletaddress \
    --protocol-params-file temp/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
    --out-file $bodyFile

  

  echo "Sign the transaction"
cardano-cli transaction sign \
    --tx-body-file $bodyFile \
    --signing-key-file $signingKey \
    $BLOCKCHAIN \
    --out-file $outFile

  echo "Submit the transaction"
  cardano-cli transaction submit \
 $BLOCKCHAIN \
 --tx-file $outFile


echo "Get the TxHash"
cardano-cli transaction txid --tx-file $outFile
set -eu