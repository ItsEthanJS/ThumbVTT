echo "Enter the path to your video file."
read video_file

echo "Enter the path to your Output Folder"
read output_folder

echo "How many seconds in between each frame?"
read frame_rate

echo "Select a Tile Size for your sprite sheets (recommended: 5)."
read tile_size

CreateSpriteSheets(){
    ffmpeg -i $video_file -vf "fps=1/$frame_rate,scale=160:90,tile=$tile_size\x$tile_size" $output_folder/SpriteSheet%1d.jpg
}

CreateVTTTimestamp() { # $1 - seconds to HH:MM:SS.000 - courtesy of https://github.com/bradmax-com/bradmax-thumbnails-tool
	echo $(printf '%02d:%02d:%02d.000' "$(( $1 / 3600))" "$(( $1 / 60 % 60))" "$(( $1 % 60))");
}

CreateVTTFile(){
    VTT_OUTPUT="WEBVTT - VTT for Thumbnail Scrubbing"
    VTT_OUTPUT+="\n"

    VidDur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $video_file)
    RoundedDur=$(echo "($VidDur+0.5)/1" | bc)
    TotalTiles=$(echo $(($RoundedDur/$frame_rate)))

    FullSpriteSheetPath=$(echo $(pwd $output_folder))

    CurrentXCoordinate=0
    CurrentYCoordinate=0
    CurrentTime=0
    
    CurrentSpriteSheetIndex=1
    CurrentSpriteSheet="$FullSpriteSheetPath/SpriteSheet$CurrentSpriteSheetIndex.jpg"

    for ((i = 0 ; i <= $TotalTiles ; i++)); do
        FirstTimestamp=$(CreateVTTTimestamp $(($CurrentTime)))
        CurrentTime=$(($CurrentTime + $(($frame_rate))))
        SecondTimestamp=$(CreateVTTTimestamp $CurrentTime)

        VTT_OUTPUT+="\n"
        VTT_OUTPUT+="$FirstTimestamp --> $SecondTimestamp"
        
        VTT_OUTPUT+="\n"
        VTT_OUTPUT+="$CurrentSpriteSheet"
        VTT_OUTPUT+="#xywh=$(expr $CurrentXCoordinate \* 160),$(expr $CurrentYCoordinate \* 90),160,90"
        VTT_OUTPUT+="\n"

        ((CurrentXCoordinate+=1))

        if [ $CurrentXCoordinate == $tile_size ]; then
            CurrentXCoordinate=0
            ((CurrentYCoordinate+=1))
            if [ $CurrentYCoordinate == $tile_size ]; then
                CurrentYCoordinate=0
                
                ((CurrentSpriteSheetIndex+=1))
                CurrentSpriteSheet="$FullSpriteSheetPath/SpriteSheet$CurrentSpriteSheetIndex.jpg"
            fi
        fi
    done

    echo -e $VTT_OUTPUT | tee file > "$output_folder/storyboard.vtt"
}

CreateSpriteSheets
CreateVTTFile