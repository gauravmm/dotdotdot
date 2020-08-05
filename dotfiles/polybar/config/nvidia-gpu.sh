#!/bin/bash

GPUDATA=$(nvidia-smi --query-gpu=index,utilization.gpu,utilization.memory,memory.used,memory.total,power.draw --format=csv,noheader,nounits | sort -n)
NVIDIA_EXIT="$?"

if [ "$NVIDIA_EXIT" -eq "127" ]; then
    echo "NO NVIDIA";
    exit
else
    if [ "$NVIDIA_EXIT" -ne "0" ]; then
        echo "NO GPU";
        exit
    fi
fi

# RAMP
RAMP_GLYPH=(▁ ▂ ▃ ▅ ▅ ▆ ▆ ▇)
RAMP_COLOR=(aaff77 aaff77 aaff77 aaff77 fba922 fba922 ff5555 ff5555)

function print_ramp {
    printf "%%{F#${RAMP_COLOR[$1]}}${RAMP_GLYPH[$1]}%%{F-}";
}

function print_ramp_percentage {
    print_ramp $(( $1 * 8 / 100 ))
}

# BAR
BAR_LEN=12
BAR_COLOR=(aaff77 aaff77 aaff77 aaff77 aaff77 aaff77 fba922  fba922  fba922 fba922 ff5555 ff5555)
BAR_EMPTY="444444"
BAR_INDICATOR="ffffff"
BAR_INDICATOR_GLYPH="|"
BAR_USED_GLYPH="─"
BAR_EMPTY_GLYPH="─"

function print_bar {
    VAL=$1;
    MAX=$2;

    # Which bar segment to pick:
    BAR_SEG=$(( $VAL * $BAR_LEN / $MAX ));

    IDX=0
    while [ $IDX -lt $BAR_SEG ]; do
        printf "%%{F#${BAR_COLOR[$IDX]}}${BAR_USED_GLYPH}";
        IDX=$(($IDX + 1))
    done

    printf "%%{F#${BAR_INDICATOR_FG}}${BAR_INDICATOR_GLYPH}";

    printf "%%{F#${BAR_EMPTY}}";
    while [ $IDX -lt $BAR_LEN ]; do
        printf $BAR_EMPTY_GLYPH;
        IDX=$(($IDX + 1))
    done
    printf "%%{F-}";
}

COLOR_POWER="444444"

printf "GPU "
printf ""

while IFS=$'\n' read -r LINE; do
    GPUPARTS=(${LINE//,/ })

    G_INDEX="${GPUPARTS[0]}"
    G_UGPU="${GPUPARTS[1]}"
    G_UMEM="${GPUPARTS[2]}"
    G_MEMU="${GPUPARTS[3]}"
    G_MEMT="${GPUPARTS[4]}"
    G_POWER="${GPUPARTS[5]}"

    print_ramp_percentage $G_UGPU;
    printf " "
    #printf "%*d%% " 3 "$G_UGPU";

    print_ramp_percentage $G_UMEM;
    printf " "
    #printf "%*d%% " 3 "$G_UMEM";

    print_bar $G_MEMU $G_MEMT
    printf " "

    printf "%%{F#${COLOR_POWER}} %*.0fW" 3 "$G_POWER"

done <<< "$GPUDATA"


printf "\n"
