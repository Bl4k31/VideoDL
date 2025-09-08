cd ~/Downloads
while true; do
    # Single download
    read -p "Download a single video? (y / blank for playlist): " SingleVideo
    if [[ ${#SingleVideo} -gt 0 ]]; then
        # Input URL for later
        read -p "Enter URL: " VideoURL
        read -p "Manualy select an audio+video format (blank for no): " SelectFormats
        if [[ ${#SelectFormats} -gt 0 ]]; then
            # List formats and ask user to select
            printf "\e[31;1mAvailable formats, DO NOT USE AV### ENCODINGS:\e[0m\n"
            yt-dlp --ffmpeg-location ~/ffmpeg2 --no-warnings --no-check-certificate --list-formats "${VideoURL}"
            printf "\e[31;1mChoose two IDs with formats from above, one 'video only' and one 'audio only', for instance 614 and 140 (these are just examples, allways check above first!)\e[0m\n"
            read -p "Enter the Video and Audio IDs to be merged as; VideoID+AudioID (e.g. 614+140): " OutputQuality
            VideoQuality2="${OutputQuality}"
        else
            # Set a minimum (Video) quality for Auto Format selection
            read -p "Minimum quality 144, 240, 360, 480, 720, 1080, 1440, 2160 (Best possible if blank): " VideoQuality
            if [[ ${#VideoQuality} -gt 0 ]]; then
                VideoQuality2="bestvideo[vcodec!*=av01][height<=?${VideoQuality}]+bestaudio[acodec=opus]/best[vcodec!*=av01]"
            else
                VideoQuality2="bestvideo[vcodec!*=av01]+bestaudio[acodec=opus]/best[vcodec!*=av01]"
            fi
        fi
        #Final Options, Filename:
        read -p "Output filename (Blank for default): " OutputName
        if [[ ${#OutputName} -eq 0 ]]; then
            OutputName="%(title)s.%(ext)s"
        else
            OutputName="${OutputName}"
        fi
        # start yt-dlp with the previous options
        yt-dlp --ffmpeg-location ~/ffmpeg2 --no-check-certificate -f "${VideoQuality2}" -o ${OutputName} --recode-video mp4 "${VideoURL}"
        # yt-dlp --ffmpeg-location ~/ffmpeg2 --no-check-certificate --cookies-from-browser chrome -f "bestvideo[vcodec!*=av01]+bestaudio[acodec=opus]/best[vcodec!*=av01]" --recode-video mp4 "https://www.youtube.com/watch?v=4sZuN0xXWLc"
        # Using ffmpeg to make a Quicktime Player readable version/format (obsolete, but kept for reference)

        #read -p "Convert to a format playable by QuickTime Player? (blank for no): " ConvertFormat
        #if [[ ${#ConvertFormat} -gt 0 ]]; then
            #read -p "Codec to use (h264, hevc, etc. - blank for h264): " Codec
            #if [[ ${#Codec} -eq 0 ]]; then
            #    ffmpeg -i ${OutputName}.mp4 -c:v h264 -c:a aac -b:a 128k ${OutputName}_h264.mp4
            #fi
            #if [[ "${Codec}" == "hevc" ]]; then
                # For HEVC, use hvc1 tag for compatibility with QuickTime Player
            #    ffmpeg -i ${OutputName}.mp4 -c:v hevc -tag:v hvc1 -c:a aac -b:a 128k ${OutputName}_hevc.mp4   
            #else
                # For other codecs, use the codec specified by the user
            #    ffmpeg -i ${OutputName}.mp4 -c:v ${Codec} -c:a aac -b:a 128k ${OutputName}_${Codec}.mp4
            #fi
        #fi

    else
        # Input URL for later
        read -p "Folder name (creates a folder for the downloaded playlist to be saved): " PlaylistLocation
        mkdir -p "${PlaylistLocation}"
        cd "./${PlaylistLocation}"
        read -p "Enter Playlist ID (&list=#####): " VideoURL
        VideoURL="https://www.youtube.com/playlist?list=${VideoURL}"
        VideoQuality2="bestvideo[vcodec!*=av01]+bestaudio[acodec=opus]/best[vcodec!*=av01]"
        #Final Options, Filename
        OutputName="%(title)s.%(ext)s"
        #Anything else needed by user
        read -p "Extra flags (--ffmpeg-location ~/ffmpeg2 --no-check-certificate -f \"bestvideo\${VideoQuality}+bestaudio/best\" -o \"${OutputName}\" --merge-output-format mp4 \${DlFlags} \"\${VideoURL}\"): " DlFlags
        yt-dlp --ffmpeg-location ~/ffmpeg2 --no-check-certificate -f "${VideoQuality2}" -o ${OutputName} --recode-video mp4 "${VideoURL}"
    fi
done
