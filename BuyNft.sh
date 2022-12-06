set -eu
thisDir=$(dirname "$0")
tempDir=$thisDir/temp
walletDir=$thisDir/wallets/$BLOCKCHAIN_PREFIX

# get walletaddress from seller
buyerwalletaddress=$(cat $walletDir/buyer.addr) 
echo "Buyerwalletaddress UTXO" $buyerwalletaddress

./QueryUtxo.sh $buyerwalletaddress

# what we buy
value="2000000 lovelace + 1 $POLICYID.$ASSETNAME" 
echo "We buy: " $value

# save protocol parameters
echo "Save protocol parameters"
cardano-cli query protocol-parameters \
    $BLOCKCHAIN \
    --out-file $tempDir/$BLOCKCHAIN_PREFIX/protocol-parameters.json



# look for the txins
changeOutput=$(cardano-cli-balance-fixer change --address $buyerwalletaddress $BLOCKCHAIN)
#echo "ChangeOutput: " $changeOutput

# if there are more tokens, we put it into extraoutput
extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi
echo "ExtraOutput: " $extraOutput

# look for inputs
txins=$(cardano-cli-balance-fixer input --address $buyerwalletaddress $BLOCKCHAIN)
echo "Inputs: " $txins



# define some variables
bodyFile=$tempDir/lockb.raw
outFile=$tempDir/lockb-signed.raw
signingKey=$walletDir/buyer.skey
signingKeyHash=$(cat $walletDir/pkhs/buyer-pkh.txt)
smartcontractaddress=$(cat $tempDir/$BLOCKCHAIN_PREFIX/smartcontract.addr)
scriptDatumHash=$(cat $tempDir/$BLOCKCHAIN_PREFIX/datums/buy-hash.txt)
utxoScript=$(./QueryUtxo.sh $smartcontractaddress | grep $scriptDatumHash | head -n 1 | cardano-cli-balance-fixer parse-as-utxo)
plutusFile=$thisDir/plutus/buy.plutus
datumFile=$tempDir/$BLOCKCHAIN_PREFIX/datums/buy.json
redeemerFile="$tempDir/$BLOCKCHAIN_PREFIX/redeemers/buy.json"
sellerwalletaddress=$(cat $walletDir/seller.addr) 
marketplaceAddr=$(cat $walletDir/marketplace.addr) 
royalitiesAddr=$(cat $walletDir/royalties.addr) 
sellerAmount="8000000 lovelace"
marketPlaceAmount="1000000 lovelace"
royaltiesAmount="1000000 lovelace"
collateral=$(cardano-cli-balance-fixer collateral --address $buyerwalletaddress $BLOCKCHAIN )

#collateral="1ca4cb3450f92e029b4e3ddfad3366f7e6864f358afb4b8cfc0e23cb294d17c4#5"

echo "Smartcontract address " $smartcontractaddress
echo "ScriptDatumHash: " $scriptDatumHash
echo "TXIN Smartcontract: " $utxoScript
echo "Buyer PKH: " $signingKeyHash
echo "Sellerwalletaddress " $sellerwalletaddress
echo "Marketplaceaddress " $marketplaceAddr
echo "Royaltiesaddress: " $royalitiesAddr
echo "Buyerwalletaddress: " $buyerwalletaddress
echo "Seller gets: " $sellerAmount
echo "Marketplace gets: " $marketPlaceAmount
echo "Royaltyrecevier gets: " $royaltiesAmount
echo "Buyer get: " $value
echo "Collateral Buyer: " $collateral
echo ""


# Create the Transaction
set -eux


cardano-cli transaction build \
    --babbage-era \
    $BLOCKCHAIN \
    $txins \
    --tx-in $utxoScript \
    --script-valid \
    --tx-in-script-file $plutusFile \
    --tx-in-datum-file $datumFile \
    --tx-in-redeemer-file $redeemerFile \
    --required-signer-hash $signingKeyHash \
    --tx-in-collateral $collateral \
    --tx-out "$sellerwalletaddress + $sellerAmount" \
    --tx-out "$buyerwalletaddress + $value" \
    --tx-out "$buyerwalletaddress + 3000000 $extraOutput" \
    --tx-out "$marketplaceAddr + $marketPlaceAmount" \
    --tx-out "$royalitiesAddr + $royaltiesAmount" \
    --change-address $buyerwalletaddress \
    --protocol-params-file temp/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
    --out-file $bodyFile


# --tx-out "$buyerwalletaddress + 3000000 lovelace + 102 a2d817f64ae600846073774fa5bfdf551b7e759e5aee715e42b1752d.574654" \

  # --tx-out-return-collateral "$buyerwalletaddress + 478767859 lovelace + 104 a2d817f64ae600846073774fa5bfdf551b7e759e5aee715e42b1752d.574654" \
   # --tx-total-collateral 1500000 \
: '
# Old version
cardano-cli transaction build \
    --babbage-era \
    $BLOCKCHAIN \
    $txins \
    --tx-in $utxoScript \
    --tx-in-script-file $plutusFile \
    --tx-in-datum-file $datumFile \
    --tx-in-redeemer-file $redeemerFile \
    --required-signer-hash $signingKeyHash \
    --tx-in-collateral $collateral \
    --tx-out "$sellerwalletaddress + $sellerAmount" \
    --tx-out "$buyerwalletaddress + $value" \
    --tx-out "$marketplaceAddr + $marketPlaceAmount" \
    --tx-out "$royalitiesAddr + $royaltiesAmount" \
    --tx-out "$buyerwalletaddress + 3000000 lovelace $extraOutput" \
    --change-address $buyerwalletaddress \
    --protocol-params-file temp/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
    --out-file $bodyFile
'

# Sign the Transaction
echo "Sign the transaction"
cardano-cli transaction sign \
    --tx-body-file $bodyFile \
    --signing-key-file $signingKey \
    $BLOCKCHAIN \
    --out-file $outFile



# Submit
  echo "Submit the transaction"
  cardano-cli transaction submit \
 $BLOCKCHAIN \
 --tx-file $outFile

# Txhash
echo "Get the TxHash"
cardano-cli transaction txid --tx-file $outFile
set -eu