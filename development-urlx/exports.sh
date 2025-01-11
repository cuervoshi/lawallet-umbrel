#!/bin/bash

ENV_FILE="${EXPORTS_APP_DIR}/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Generating persistent keys for the first time..."

    NOSTR_PRIVATE_KEY=$(openssl rand -hex 32)
    NOSTR_PUBLIC_KEY=$(echo -n "$NOSTR_PRIVATE_KEY" | sha256sum | awk '{print $1}')

    cat <<EOF > "$ENV_FILE"
NOSTR_PRIVATE_KEY=$NOSTR_PRIVATE_KEY
NOSTR_PUBLIC_KEY=$NOSTR_PUBLIC_KEY
EOF

    echo "Keys saved to $ENV_FILE."
fi

source "$ENV_FILE"

export NOSTR_PRIVATE_KEY
export NOSTR_PUBLIC_KEY

echo "Keys exported: PRIVATE_KEY=$NOSTR_PRIVATE_KEY, PUBLIC_KEY=$NOSTR_PUBLIC_KEY"
