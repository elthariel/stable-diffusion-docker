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

if [ -n "$HF_REPO" -a -n "$HF_TOKEN" -a \! -f /workspace/repo ]; then
    git clone https://$HF_USERNAME:$HF_TOKEN@huggingface.co/datasets/$HF_REPO \
        /workspace/repo
fi

if [[ -d "/workspace/repo" ]]; then
    echo "Running repo setup scripts..."
    bash /workspace/repo/start.sh
fi

ATUIN_USER=${ATUIN_USER:-coolta}
if [ -n "$ATUIN_PASSWORD" -a -n "$ATUIN_KEY" -a -f /usr/bin/atuin ]; then
    echo "Logging in to atuin sync server"
    atuin login -u "$ATUIN_USER" -p "$ATUIN_PASSWORD" -k "$ATUIN_KEY"
    atuin store pull
fi

envfile='/.env'
echo "Storing start environment into $envfile"
env > "$envfile"
chmod 600 "$envfile"
