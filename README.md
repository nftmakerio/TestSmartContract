# TestSmartContract

### Required Components
1. Cardano-cli-balance-fixer:
https://github.com/Canonical-LLC/cardano-cli-balance-fixer

2. Deadalus Wallet (or Cardano Node)
https://daedaluswallet.io/



## How to start
### 1. Source the Envvars (before set the policyid and assetname)
In the Envvars you define the policyid and the nftname (in HEX)
```console
source ./Preprod.Envvars
```


### 2. Then Create the Wallets
```console
./CreateWallets.sh
```


### 3. Fill the Seller Wallet with ADA and the Token(s)
Send enough ADA and the Tokens to the Seller Wallet Address

### 4. Check The Utxo:
```console
./GetUtxos.sh
```


### 5. Create the Datums:
In the Datums the Address for the Seller, Buyer, Royalties and Markteplace are used. If you want to use an other wallet address, you have to specifiy the addressed here
```console
./MakeDatums.sh
```


### 6. Hash the Datums:
```console
./HashDatums.sh
```


### 7. Lock the NFT into the Smartcontract
```console
./LockNftInSmartcontract.sh
```


### 8. Query the Smartcontract if the txhash is there
```console
./QueryTheSmartContract.sh
```


### 9. Fill the Buyer Wallet with ADA (if not already done)
You need at least the amount what it costs + 3 ADA for extraoutput + 1 ADA for the changeaddress.
So if the NFT costs 8, have at least 12 ADA in the Wallet

### 10. Buy the NFT
```console
./BuyNft.sh
```



