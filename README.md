# TestSmartContract

## Source the Envvars (before set the policyid and assetname)
source ./Preprod.Envvars

## Then Create the Wallets
./CreateWallets.sh

## Fill the Seller Wallet with ADA and the Token(s)

## Check The Utxo:
./GetUtxos.sh

## Create the Datums:
./MakeDatums.sh

## Hash the Datums:
./HashDatums.sh

## Lock the NFT into the Smartcontract
./LockNftInSmartcontract.sh

## Query the Smartcontract if the txhash is there
./QueryTheSmartContract.sh

## Fill the Buyer Wallet with ADA (if not already done)

## Buy the NFT
./BuyNft.sh


