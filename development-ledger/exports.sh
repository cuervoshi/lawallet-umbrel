#!/bin/bash

ENV_FILE="${EXPORTS_APP_DIR}/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Generating persistent keys for the first time..."

    # Generating keys for LAWALLET_LEDGER
    LAWALLET_LEDGER_PRIVATE_KEY=$(openssl rand -hex 32)
    LAWALLET_LEDGER_PUBLIC_KEY=$(echo -n "$LAWALLET_LEDGER_PRIVATE_KEY" | sha256sum | awk '{print $1}')

    # Generating keys for LAWALLET_MINTER
    LAWALLET_MINTER_PRIVATE_KEY=$(openssl rand -hex 32)
    LAWALLET_MINTER_PUBLIC_KEY=$(echo -n "$LAWALLET_MINTER_PRIVATE_KEY" | sha256sum | awk '{print $1}')

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
