#! /bin/bash

if [[ -n "$AWS_SECRET_ACCESS_KEY" ]]; then
    conf="[sync]\ntype = s3\nprovider = AWS"
    conf="$conf\naccess_key_id=$AWS_ACCESS_KEY_ID"
    conf="$conf\nsecret_access_key=$AWS_SECRET_ACCESS_KEY"
    conf="$conf\region=$AWS_DEFAULT_REGION"
    mkdir -p ~/.config/rclone
    echo "$conf" > ~/.config/rclone/rclone.conf

    rclone copy -P --fast-list --transfers=4 \
           "sync:$S3_SYNC_PATH" "/workspace/$HF_USERNAME"
fi

if [[ -d /workspace/elthariel/experiments ]]; then
    echo "Running Lta's setup scripts..."
    python /workspace/elthariel/experiments/helpers/system.py
    python /workspace/elthariel/experiments/start.py
fi

echo "Installing extensions..."
cd /stable-diffusion-webui
git clone --depth=1 https://github.com/Zyin055/Config-Presets.git\
    extensions/Config-Presets
