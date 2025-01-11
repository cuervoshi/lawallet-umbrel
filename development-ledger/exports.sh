#!/bin/bash

ENV_FILE="${EXPORTS_APP_DIR}/.env"

generate_key_pair() {
    key_data=$(openssl ecparam -name secp256k1 -genkey | openssl ec -text -noout -conv_form=compressed 2> /dev/null | grep '^ ')

    priv_key=$(echo "${key_data}" | head -n3 | tr -cd 0123456789abcdef)
    pub_key=$(echo "${key_data}" | tail -n3 | tr -cd 0123456789abcdef | tail -c+3)

    echo "${priv_key}:${pub_key}"
}

if [ ! -f "$ENV_FILE" ]; then
    echo "Generating persistent keys for the first time..."

    # Generating keys for LAWALLET_LEDGER
    ledger_key_pair=$(generate_key_pair)
    LAWALLET_LEDGER_PRIVATE_KEY="${ledger_key_pair%:*}"
    LAWALLET_LEDGER_PUBLIC_KEY="${ledger_key_pair#*:}"

    # Generating keys for LAWALLET_MINTER
    minter_key_pair=$(generate_key_pair)
    LAWALLET_MINTER_PRIVATE_KEY="${minter_key_pair%:*}"
    LAWALLET_MINTER_PUBLIC_KEY="${minter_key_pair#*:}"

    cat <<EOF > "$ENV_FILE"
LAWALLET_LEDGER_PRIVATE_KEY=$LAWALLET_LEDGER_PRIVATE_KEY
LAWALLET_LEDGER_PUBLIC_KEY=$LAWALLET_LEDGER_PUBLIC_KEY
LAWALLET_MINTER_PRIVATE_KEY=$LAWALLET_MINTER_PRIVATE_KEY
LAWALLET_MINTER_PUBLIC_KEY=$LAWALLET_MINTER_PUBLIC_KEY
EOF

    echo "Keys saved to $ENV_FILE."
fi

source "$ENV_FILE"

export LAWALLET_LEDGER_PRIVATE_KEY
export LAWALLET_LEDGER_PUBLIC_KEY
export LAWALLET_MINTER_PRIVATE_KEY
export LAWALLET_MINTER_PUBLIC_KEY

echo "Keys exported: \
  LEDGER_PRIVATE_KEY=$LAWALLET_LEDGER_PRIVATE_KEY, LEDGER_PUBLIC_KEY=$LAWALLET_LEDGER_PUBLIC_KEY \
  MINTER_PRIVATE_KEY=$LAWALLET_MINTER_PRIVATE_KEY, MINTER_PUBLIC_KEY=$LAWALLET_MINTER_PUBLIC_KEY"
