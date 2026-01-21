echo "Content Downloader Auto-install"
cd ~
UserDIR="$(echo $HOME)"
printf "\e[31;1mThis script will install the required packages for the Content Downloader.\e[0m\n"
printf "\e[33;1mPlease note that the downloaders shell scripts can be run from anywhere and will not be moved by this script.\e[0m\n"
printf "\e[33;1mIt might also be smart to create a shortcut to the script files you use most for easier access.\e[0m\n"
printf "\e[33;1mDownloaded videos will default to the downloads folder, to change this, please edit the scripts.\e[0m\n"
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
    # Check if yt-dlp is installed, if not, install it
    if ! command -v yt-dlp &> /dev/null; then
        # `command -v yt-dlp` returns 0 if found, non-zero if not.
        # `!` negates the exit status, so the block runs if `yt-dlp` is NOT found.
        # `&> /dev/null` suppresses any output from `command -v`
        echo "Installing yt-dlp..."
        pip"${pip_command}" install yt-dlp
        echo "yt-dlp installed successfully."
    else
        echo "yt-dlp is already installed."
    fi

# Check if ffmpeg is installed, if not, install it
    if ! command -v ffmpeg &> /dev/null; then
    # `command -v ffmpeg` returns 0 if found, non-zero if not.
    # `!` negates the exit status, so the block runs if `ffmpeg` is NOT found.
    # `&> /dev/null` suppresses any output from `command -v`

        echo "ffmpeg not found. Installing ffmpeg..."
        read -p "Press Enter to continue..."
        printf "\e[44;1mCloning ffmpeg repository.\e[0m\n"
        git clone https://github.com/FFmpeg/FFmpeg.git ~/ffmpeg2
        printf "\e[42;1mSuccessfully cloned ffmpeg.\e[0m\n"
        cd ~/ffmpeg2
        printf "\e[44;1mConfiguring ffmpeg.\e[0m\n"
        ./configure
        make -j
        make install -j
        printf "\e[42;1mffmpeg configured and built successfully.\e[0m\n"
        echo "ffmpeg installed successfully."
        echo "Adding ffmpeg to PATH..."
        echo "export PATH=\"${UserDIR}/ffmpeg2:\$PATH\"" >> ~/.zshrc
        echo "ffmpeg is now in your PATH."
        source ~/.zshrc
        echo "You can now use ffmpeg from anywhere in your terminal."
        read -p "Press Enter to continue..."

        echo "You can now use ffmpeg from anywhere in your terminal."
    else
        echo "ffmpeg is already installed."
    fi