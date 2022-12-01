
thisDir=$(dirname "$0")
walletDir=$thisDir/wallets/$BLOCKCHAIN_PREFIX

mkdir -p wallets
mkdir -p wallets/$BLOCKCHAIN_PREFIX


if [ ! -f $walletDir/$1.vkey  ]; then
cardano-cli address key-gen --verification-key-file $walletDir/$1.vkey --signing-key-file $walletDir/$1.skey
cardano-cli address build $BLOCKCHAIN --payment-verification-key-file $walletDir/$1.vkey --out-file $walletDir/$1.addr
fi

mkdir -p $walletDir/pkhs

#if [ ! -f $walletDir/pkhs/$1-pkh.txt  ]; then
cardano-cli address key-hash --payment-verification-key-file $walletDir/$1.vkey > $walletDir/pkhs/$1-pkh.txt
#fi


echo $1 Address - $(cat $walletDir/$1.addr)
echo $1 PKH - $(cat $walletDir/pkhs/$1-pkh.txt)