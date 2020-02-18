#! /bin/bash
########################################################################
# AUTHOR: Peter Procek
########################################################################

########################################################################
# Fancy Formatting
########################################################################
RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHTBLUE='\033[1;34m'
NC='\033[0m' # No Color

########################################################################
# Template Default messages
########################################################################
USERINPUT=''
TARGET=''
DIRNAME=''

YES="${GREEN}YES${NC}"
NO="${RED}NO${NC}"

SYSPROMPT="ENTER THE SYSTEM YOU WOULD LIKE TO CONFIGURE THE BUILD FOR"
DEFAULTSYS="SAMA5D36"
STARTMESSAGE="Setting up Yocto environment for: ${LIGHTBLUE}${DEFAULTSYS}${NC}"
DEPCHECK="CHECKING CURRENT ENVIRONMENT FOR:"
ERROR="${RED}*****ERROR*****${NC}"

########################################################################
# Globals
########################################################################
declare -A SUPPORTED
declare -A REPOSITORIES
declare -A PACKAGES


SUPPORTED["SAMA5D36"]="YES"

########################################################################
# Functions
########################################################################

fecho()
{
    echo -e $1
}

prompt()
{
    echo -n "$1: "
    read input 
    USERINPUT=${input}
}

isSupported()
{
    if [[ ${SUPPORTED["$1"]} == "YES" ]]; then 
        return 1
    fi
}

populateComponents()
{
    declare -A NEEDED_REPOSITORIES
    declare -A NEEDED_PACKAGES

    case "${TARGET}" in 

        SAMA5D36)
            #necessary cross compiler
            PACKAGES["CROSS_COMPILE"]="gcc-arm-linux-gnueabi"
            PACKAGES["libncurses5"]="libncurses5-dev"
            PACKAGES["libncurses5"]="libncursesw5-dev"

            REPOSITORIES["U-BOOT"]="git://github.com/linux4sam/u-boot-at91.git"
            REPOSITORIES["AT91BOOTSTRAP"]="git://github.com/linux4sam/at91bootstrap.git"
            REPOSITORIES["LINUX-AT91"]="git://github.com/linux4sam/linux-at91.git"
            REPOSITORIES["META-ATMEL"]="git://github.com/linux4sam/meta-atmel.git"
            REPOSITORIES["POKY"]="git://git.yoctoproject.org/poky"
            REPOSITORIES["META-OPENEMBEDDED"]="git://git.openembedded.org/meta-openembedded"
            REPOSITORIES["META-QT5"]="git://code.qt.io/yocto/meta-qt5.git"  

            for key in "${!REPOSITORIES[@]}"; do
                CURDEPENDENCY=${key}
                DIRNAME=${REPOSITORIES["${CURDEPENDENCY}"]}
                DIRNAME=${DIRNAME##*/}
                DIRNAME=$(cut -d'.' -f1 <<< ${DIRNAME})

                if [ -d "./${DIRNAME}" ]; then 
                    fecho "${DEPCHECK} ${CURDEPENDENCY}..........${YES}"
                else 
                    fecho "${DEPCHECK} ${CURDEPENDENCY}..........${NO}"
                    NEEDED_REPOSITORIES["${CURDEPENDENCY}"]="${REPOSITORIES["${CURDEPENDENCY}"]}"
                fi

            done

            fecho "Cloning missing repositories..."
            for repo in "${NEEDED_REPOSITORIES[@]}";do 
                $(git clone --progress ${repo})
            done

            # for key in "${!REPOSITORIES[@]}"; do
            #     CURDEPENDENCY=${key}
            #     DIRNAME=${REPOSITORIES["${CURDEPENDENCY}"]}
            #     DIRNAME=${DIRNAME##*/}
            #     DIRNAME=$(cut -d'.' -f1 <<< ${DIRNAME})

            #     if [ -d "./${DIRNAME}" ]; then 
            #         fecho "${DEPCHECK} ${CURDEPENDENCY}..........${YES}"
            #     else 
            #         fecho "${DEPCHECK} ${CURDEPENDENCY}..........${NO}"
            #         NEEDED_REPOSITORIES["${CURDEPENDENCY}"]=REPOSITORIES["${CURDEPENDENCY}"]
            #     fi

            # done


            ;;
        *)
            echo -n "no repositories found"
    esac
}

installComponents()
{
    #iterate and check if all needed components exist
    return

}

isRoot()
{
    if [ "$EUID" -ne 0 ]; then
        fecho "${ERROR}: PLEASE RUN AS ROOT"
        return 0
    else 
        return 1
    fi
}

dirExists()
{
    PATH=$1
    if [[ -d "$PATH" ]]; then
        return 1
    fi
}

packageExists()
{
    return
}

checkDependency()
{
    PATH=$1

    if dirExists;then
        return
    else 
        return
    fi

}

checkRepositories()
{
    return
}

checkToolChain()
{
    return
}

populateRepositories()
{
    return
}

########################################################################
# MAIN SCRIPT
########################################################################
isRoot

if [ "$?" -ne 0 ]; then 

    prompt "${SYSPROMPT}"

    TARGET=${USERINPUT}

    isSupported "${TARGET}"

    if [ "$?" -ne 0 ]; then 
        populateComponents
        fecho "\n${STARTMESSAGE}"
    else 
        fecho "${ERROR}: DEVICE NOT SUPPORTED"
    fi
fi
