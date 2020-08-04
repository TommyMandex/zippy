#!/bin/bash
#
# get info from kit zip files

# Last update: 2020-08-03
# usage:	
#			zippy.sh -f ZIPFILE [-r]
#			zippy.sh -d DIR_FULL_OF_ZIPS [-r]

#
# main tools: zipinfo (unzip) + (TODO)zipgrep


VERSION=0.1

COLOR_RED="\033[0;31m"
COLOR_RED_LIGHT="\033[1;31m"
COLOR_GREEN="\033[0;32m"
COLOR_GREEN_LIGHT="\033[1;32m"
COLOR_ORANGE="\033[0;33m"
COLOR_YELLOW="\033[1;33m"
COLOR_END="\033[0m"

SINGLE_FILE=0
DIRECTORY=0
REMOVE_FILES=0
OTHER_ARGUMENTS=()

function usage {
	echo -e "Usage:"
	echo -e "\t $0 -f badass_phishing_kit.zip [-r]"
	echo -e "\t $0 -d DIRECTORY_FULL_OF_ZIPS [-r]"
	echo -e "\t $0 --help\n"
	echo -e "\t OPTION -r (--remove) removes file with .zip extension if it's not a zip (careful, won't ask confirmation!)\n"
}

# check args
if [[ "$#" -lt 1  || ("$#" -eq 1  && ("$1" == "--remove" || "$1" == "-r")) ]]; then
    usage
    exit 1
fi
# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        --help)
		if [ $DIRECTORY -eq 1 ] || [ $SINGLE_FILE -eq 1 ]; then
			echo -e "Wrong use of help!"
			usage
			exit 1
		fi
		echo -e "Zippy ${VERSION} by @dave_daves"
		usage
		exit 0
        ;;        
        -f|--file)
		if [ $DIRECTORY -eq 1 ] || [ -z "$2" ]
		then
			usage
			exit 1
		fi
        SINGLE_FILE=1
        ZIP="$2"
        shift # Remove --file from processing
        shift # Remove filename from processing
        ;;
        -d|--dir)
		if [ $SINGLE_FILE -eq 1 ] || [ -z "$2" ]
		then
			usage
			exit 1
		fi        
		DIRECTORY=1
        DIR="${2%/}"
        shift # Remove --dir from processing
        shift # Remove dirname from processing
        ;;
        -r|--remove)
		REMOVE_FILES=1
		shift	
		;;
        *)
        OTHER_ARGUMENTS+=("$1")
        echo -e "Invalid argument! ${1}"
        usage
        exit 1
        #shift # Remove generic argument from processing
        ;;
    esac
done

function zip_man {
	# check if file exists
	if ! [ -f "$1" ]; then
		printf "\n"
		echo "File not found!"
		return 1
	fi
	# check if file is .zip
	FILEOUT=`file "$1"`
	if ! [[ $FILEOUT == *"Zip archive"* ]]; then
		printf "\n"
		echo "Not a zip file!"
		echo "$FILEOUT"
		#remove file? (force remove, no prompt)
		if [ $REMOVE_FILES -eq 1 ]; then
			rm -f "$1"
		fi
		return 1
	fi

	zipext=\.zip
	TXT=${1//$zipext}
	# if not already there, write txt file with zip content
	# (remove __MACOSX files/dirs)
	if ! [ -f "${TXT}.txt" ]; then
		zipinfo -1 "${1}" \* | sort | grep -v ^"__MACOSX" > "${TXT}.txt"
	fi
}


if [ $SINGLE_FILE -eq 1 ]
then
	echo -e "${COLOR_GREEN}Single ZIP file: \t${COLOR_END} $ZIP"
	# check if file exists
	if ! [ -f "${ZIP}" ]; then
		printf "\n"
		echo "File not found!"
		exit 1
	fi
	zip_man "${ZIP}"
	exit 0

elif [ $DIRECTORY -eq 1 ]
then
	echo -e "${COLOR_YELLOW}Directory: \t\t${COLOR_END} $DIR"
	# check if dir exists
	if ! [ -d "${DIR}" ]; then
		printf "\n"
		echo "Directory not found!"
		exit 1
	fi
	for file in "${DIR}"/*.zip
	do 
		zip_man "$file"
	done
	exit 0
fi


# echo size and filename
#du -skh "${ZIP}"


