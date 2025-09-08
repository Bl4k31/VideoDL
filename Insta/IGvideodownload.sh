cd ~/Downloads
while true; do
    # Input URL for later
    read -p "Enter URL: " VideoURL
    read -p "Manualy select an audio+video format (blank for no): " SelectFormats
    if [[ ${#SelectFormats} -gt 0 ]]; then
        # List formats and ask user to select
        printf "\e[31;1mAvailable formats, Usually only works with UNKNOWN encodings:\e[0m\n"
        yt-dlp --ffmpeg-location ~/ffmpeg2 --no-warnings --no-check-certificate --list-formats "${VideoURL}"
        # --cookies-from-browser chrome
        printf "\e[31;1mChoose a format from above\e[0m\n"
        read -p "Enter the format ID to be used (e.g. 1): " OutputQuality
        VideoQuality2="${OutputQuality}"
    else
        VideoQuality2=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
    fi
    #Final Options, Filename:
    read -p "Output filename (Blank for default): " OutputName
    if [[ ${#OutputName} -eq 0 ]]; then
        OutputName="%(title)s[%(id)s].mp4"
    else
        OutputName="${OutputName}"
    fi
    # start yt-dlp with the previous options
    yt-dlp --ffmpeg-location ~/ffmpeg2 --no-check-certificate -f "${VideoQuality2}" -o ${OutputName} --recode-video mp4 "${VideoURL}"
    #--cookies-from-browser chrome
done