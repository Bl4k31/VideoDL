echo "Content Downloader Auto-install"
cd ~
UserDIR="$(echo $HOME)"
printf "\e[31;1mThis script will install the required packages for the Content Downloader.\e[0m\n"
read -p "Press Enter to continue..."
    while true; do
        read -p "What is the version of pip (python required) pip<#.##>: " pip_command
        if ! command -v pip"${pip_command}" &> /dev/null; then
            echo "command pip${pip_command} not found. Please ensure you have Python and pip ${pip_command} installed and the input matches the format."
            echo "Please re-enter pip version number."
        else
            echo "pip${pip_command} found."
            break
        fi
    done
    if echo "$PATH" | grep -q "${UserDIR}/Library/Python/${pip_command}/bin"; then
        echo "pip${pip_command} bin already in PATH, skipping addition."
    else
        echo "Will add pip${pip_command} bin to PATH"
        export PATH="${UserDIR}/Library/Python/${pip_command}/bin:$PATH"
        source ~/.zshrc
    fi
    echo "Installing yt-dlp..."
    pip"${pip_command}" install yt-dlp
    echo "yt-dlp installed successfully."

# Check if ffmpeg is installed, if not, install it
    if ! command -v ffmpeg2 &> /dev/null; then
    # `command -v ffmpeg` returns 0 if found, non-zero if not.
    # `!` negates the exit status, so the block runs if `ffmpeg` is NOT found.
    # `&> /dev/null` suppresses any output from `command -v`

        echo "ffmpeg not found. Installing ffmpeg..."
        git clone https://github.com/FFmpeg/FFmpeg.git ~/ffmpeg3
        printf "\e[42;1mSuccessfully cloned ffmpeg.\e[0m\n"
        cd ~/ffmpeg3
        printf "\e[44;1mConfiguring ffmpeg.\e[0m\n"
        ./configure
        make -j
        make install -j
        printf "\e[42;1mffmpeg configured and built successfully.\e[0m\n"
        echo "ffmpeg installed successfully."
        echo "Adding ffmpeg to PATH..."
        #echo "export PATH=\"${UserDIR}/ffmpeg2:\$PATH\"" >> ~/.zshrc
        echo "ffmpeg is now in your PATH."
        source ~/.zshrc
        echo "You can now use ffmpeg from anywhere in your terminal."
        read -p "Press Enter to continue..."

        echo "You can now use ffmpeg from anywhere in your terminal."
    else
        echo "ffmpeg is already installed."
    fi