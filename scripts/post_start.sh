#! /bin/bash

if [[ -n "$AWS_SECRET_ACCESS_KEY" ]]; then
    mkdir -p ~/.config/rclone
    conf_path="$HOME/.config/rclone/rclone.conf"

    echo "[sync]" > "$conf_path"
    echo 'type=s3' >> "$conf_path"
    echo 'provider=AWS' >> "$conf_path"
    echo "access_key_id=$AWS_ACCESS_KEY_ID" >> "$conf_path"
    echo "secret_access_key=$AWS_SECRET_ACCESS_KEY" >> "$conf_path"
    echo "region=$AWS_DEFAULT_REGION" >> "$conf_path"

    rclone copy -P --fast-list --transfers=4 \
           "sync:$S3_SYNC_PATH" "/workspace/$HF_USERNAME" \
           | tee /tmp/rclone.log
fi

echo "Installing extensions..."
cd /workspace/stable-diffusion-webui
git clone --depth=1 https://github.com/Zyin055/Config-Presets.git \
    extensions/Config-Presets


echo "Setting JPLab theme to dark..."
cfg='{"theme": "JupyterLab Dark"}'
cfg_dir="$HOME/.jupyter/lab/user-settings/@jupyterlab/apputils-extension"
cfg_file="$cfg_dir/themes.jupyterlab-settings"
mkdir -p "$cfg_dir"
echo "$cfg" > "$cfg_file"

if [[ -d /workspace/elthariel/experiments ]]; then
    echo "Running Lta's setup scripts..."
    python /workspace/elthariel/experiments/helpers/system.py
    python /workspace/elthariel/experiments/start.py
fi
