#!/usr/bin/env bash
shopt -s extglob

# Various options for the file browser script:
ROFI_FB_GENERIC_FO="xdg-open" # command used for opening the selection
ROFI_FB_PREV_LOC_FILE=~/.local/share/rofi/rofi_fb_prevloc
ROFI_FB_HISTORY_FILE=~/.local/share/rofi/rofi_fb_history 
ROFI_FB_HISTORY_MAXCOUNT=1 # maximum number of history entries
# Comment the next variable to always start in the last visited directory,
# otherwise rofi_fb will start in the specified directory:
ROFI_FB_START_DIR=$HOME # starting directory
# Uncomment the following line to disable history:
ROFI_FB_NO_HISTORY=1

# Flag to open the directory
ROFI_FB_FLAG_WIDTH=2
ROFI_FB_FLAG_OPENDIR="➚ "
ROFI_FB_FLAG_FILE="  "
ROFI_FB_FLAG_DIR="  "

# Beginning of the script:
# Create the directory for the files of the script
if [ ! -d $(dirname "${ROFI_FB_PREV_LOC_FILE}") ]
then
    mkdir -p "$(dirname "${ROFI_FB_PREV_LOC_FILE}")"
fi
if [ ! -d $(dirname "${ROFI_FB_HISTORY_FILE}") ]
then
    mkdir -p "$(dirname "${ROFI_FB_HISTORY_FILE}")"
fi

# Initialize $ROFI_FB_CUR_DIR
if [ -d "${ROFI_FB_START_DIR}" ]
then
    ROFI_FB_CUR_DIR="${ROFI_FB_START_DIR}"
else
    ROFI_FB_CUR_DIR="$PWD"
fi

# Read last location, otherwise we default to $ROFI_FB_START_DIR or $PWD.
if [ -f "${ROFI_FB_PREV_LOC_FILE}" ]
then
    ROFI_FB_CUR_DIR=$(cat "${ROFI_FB_PREV_LOC_FILE}") 
fi 


# Open the local directory?
ROFI_FB_OPENDIR=0

# Handle argument.
# Trim the argstring
ROFI_FB_ARGS="${@##*( )}"
if [ -n "$@" ]
then
    if [[ "$@" == /* ]]
    then
        ROFI_FB_CUR_DIR="$@"
    elif [[ "$@" =~ ^\w*~\w*$ ]]
    then
        ROFI_FB_CUR_DIR=$HOME
    elif [[ "${ROFI_FB_ARGS:0:${#ROFI_FB_FLAG_OPENDIR}}" == "$ROFI_FB_FLAG_OPENDIR" ]]
    then
        ROFI_FB_OPENDIR=1
        ROFI_FB_CUR_DIR="${ROFI_FB_ARGS:${#ROFI_FB_FLAG_OPENDIR}}"
    else
        ROFI_FB_CUR_DIR="${ROFI_FB_CUR_DIR}/$ROFI_FB_ARGS"
    fi
fi

# If argument is no directory.
if [[ ! -d "${ROFI_FB_CUR_DIR}" || $ROFI_FB_OPENDIR == 1 ]]
then
    if [[ -x "${ROFI_FB_CUR_DIR}" && ! $ROFI_FB_OPENDIR == 1 ]]
    then
        coproc ( "${ROFI_FB_CUR_DIR}"  > /dev/null 2>&1 )
        exec 1>&-
        exit;
    elif [[ -f "${ROFI_FB_CUR_DIR}" || $ROFI_FB_OPENDIR == 1 ]]
    then
        if [[ "${ROFI_FB_NO_HISTORY}" -ne 1 ]]
        then
            # Append selected entry to history and remove exceeding entries
            sed -i "s|${ROFI_FB_CUR_DIR}|##deleted##|g" "${ROFI_FB_HISTORY_FILE}"
            sed -i '/##deleted##/d' "${ROFI_FB_HISTORY_FILE}"
            echo "${ROFI_FB_CUR_DIR}" >> "${ROFI_FB_HISTORY_FILE}"
            if [ $(cat "${ROFI_FB_HISTORY_FILE}" | wc -l) -gt ${ROFI_FB_HISTORY_MAXCOUNT} ]
            then
                sed -i 1d "${ROFI_FB_HISTORY_FILE}"
            fi
        fi
        # Open the selected entry with $ROFI_FB_GENERIC_FO
        coproc ( "${ROFI_FB_GENERIC_FO}" "${ROFI_FB_CUR_DIR}"  > /dev/null  2>&1 )
        if [ -d "${ROFI_FB_START_DIR}" ]
        then
            echo "${ROFI_FB_START_DIR}" > "${ROFI_FB_PREV_LOC_FILE}"
        fi
        exit;
    fi
    exit;
fi

# Process current dir.
if [ -n "${ROFI_FB_CUR_DIR}" ]
then
    ROFI_FB_CUR_DIR=$(readlink -e "${ROFI_FB_CUR_DIR}")
    echo "${ROFI_FB_CUR_DIR}" > "${ROFI_FB_PREV_LOC_FILE}"
    pushd "${ROFI_FB_CUR_DIR}" >/dev/null
fi

# Output to rofi
if [[ "${ROFI_FB_NO_HISTORY}" -ne 1 && -f "${ROFI_FB_HISTORY_FILE}" ]]
then
    tac "${ROFI_FB_HISTORY_FILE}" | grep "^${ROFI_FB_CUR_DIR}"
fi
echo "${ROFI_FB_FLAG_OPENDIR}${ROFI_FB_CUR_DIR}/"
echo "${ROFI_FB_FLAG_DIR}.."
while IFS= read -r file
do
    if [ ! -z "${file// }" ]
    then
        if [ -d "$file" ]
        then
            echo "${ROFI_FB_FLAG_DIR}$file/"
        else
            echo "${ROFI_FB_FLAG_FILE}$file"
        fi
    fi
done <<< $(ls "${ROFI_FB_CUR_DIR}")
