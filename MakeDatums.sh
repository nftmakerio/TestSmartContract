set -eu
thisDir=$(dirname "$0")
tempDir=$thisDir/temp
walletDir=$thisDir/wallets/$BLOCKCHAIN_PREFIX

mkdir -p $tempDir/$BLOCKCHAIN_PREFIX/datums
mkdir -p $tempDir/$BLOCKCHAIN_PREFIX/redeemers

sellerPkh=$(cat $walletDir/pkhs/seller-pkh.txt)
marketplacePkh=$(cat $walletDir/pkhs/marketplace-pkh.txt)
royaltyPkh=$(cat $walletDir/pkhs/royalties-pkh.txt)
buyerPkh=$(cat $walletDir/pkhs/buyer-pkh.txt)

cat << EOF > $tempDir/$BLOCKCHAIN_PREFIX/datums/buy.json
{
  "constructor": 0,
  "fields": [
    {
      "bytes": "$sellerPkh"
    },
    {
      "list": [
        {
          "constructor": 0,
          "fields": [
            {
              "bytes": "$sellerPkh"
            },
            {
              "map": [
                {
                  "k": {
                      "bytes": ""
                    },
                  "v": {
                    "map":[
                      { "k":
                        {
                          "bytes": ""
                        },
                        "v":
                        {
                          "int": 8000000
                        }
                      }
                    ]
                  }
                }
              ]
            }
          ]
        },
        {
          "constructor": 0,
          "fields": [
            {
              "bytes": "$marketplacePkh"
            },
            {
              "map": [
                {
                  "k":
                    {
                      "bytes": ""
                    },
                  "v": {
                    "map": [
                      { "k":
                        {
                          "bytes": ""
                        }
                      ,
                        "v":
                        {
                          "int": 1000000
                        }
                      }
                    ]
                  }
                }
              ]
            }
          ]
        },
        {
          "constructor": 0,
          "fields": [
            {
              "bytes": "$royaltyPkh"
            },
            {
              "map": [
                {
                  "k": {
                      "bytes": ""
                    },
                  "v": {
                    "map": [
                      {
                        "k": {
                      "bytes": ""
                    },
                        "v":
                        {
                          "int": 1000000
                        }
                      }
                    ]
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}

EOF

cat << EOF > $tempDir/$BLOCKCHAIN_PREFIX/redeemers/buy.json
{
  "constructor": 1,
  "fields": [
    {
      "list": [
        {
          "constructor": 0,
          "fields": [
            {
              "bytes": "$buyerPkh"
            },
            {
              "map": [
                {
                  "k": {
                    "bytes": "$POLICYID"
                  },
                  "v": {
                    "map": [
                      {
                        "k": {
                          "bytes": "$ASSETNAME"
                        },
                        "v": {
                          "int": 1
                        }
                      }
                    ]
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}

EOF

cat << EOF > $tempDir/$BLOCKCHAIN_PREFIX/datums/buy2.json
{
  "constructor": 0,
  "fields": [
    {
      "bytes": "$sellerPkh"
    },
    {
      "list": [
        {
          "constructor": 0,
          "fields": [
            {
              "bytes": "$sellerPkh"
            },
            {
              "map": [
                {
                  "k": {
                      "bytes": ""
                    },
                  "v": {
                    "map":[
                      { "k":
                        {
                          "bytes": ""
                        },
                        "v":
                        {
                          "int": 8000000
                        }
                      }
                    ]
                  }
                }
              ]
            }
          ]
        },
        {
          "constructor": 0,
          "fields": [
            {
              "bytes": "$marketplacePkh"
            },
            {
              "map": [
                {
                  "k":
                    {
                      "bytes": ""
                    },
                  "v": {
                    "map": [
                      { "k":
                        {
                          "bytes": ""
                        }
                      ,
                        "v":
                        {
                          "int": 1000000
                        }
                      }
                    ]
                  }
                }
              ]
            }
          ]
        },
        {
          "constructor": 0,
          "fields": [
            {
              "bytes": "$royaltyPkh"
            },
            {
              "map": [
                {
                  "k": {
                      "bytes": ""
                    },
                  "v": {
                    "map": [
                      {
                        "k": {
                      "bytes": ""
                    },
                        "v":
                        {
                          "int": 1000000
                        }
                      }
                    ]
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}

EOF

cat << EOF > $tempDir/$BLOCKCHAIN_PREFIX/redeemers/buy2.json
{
  "constructor": 1,
  "fields": [
    {
      "list": [
        {
          "constructor": 0,
          "fields": [
            {
              "bytes": "$buyerPkh"
            },
            {
              "map": [
                {
                  "k": {
                    "bytes": "$POLICYID"
                  },
                  "v": {
                    "map": [
                      {
                        "k": {
                          "bytes": "$ASSETNAME"
                        },
                        "v": {
                          "int": 1
                        }
                      }
                    ]
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}

EOF
