#!/bin/bash
# Colors
RED="\033[0;31m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
RESET="\033[0m"

# Errors variables
ERROR=false
NPM_ERROR=false

# Node files and directories
PACKAGE_LOCK="package-lock.json"
YARN_LOCK="yarn.lock"
PNPM_LOCK="pnpm-lock.yaml"
PACKAGE="package.json"
NODE_MODULES="node_modules"

# Commands
COMMAND="$1"
OPTION="$2"

COMMAND_MAN="
USAGE: 
    nmgc <COMMAND> [OPTIONS]

COMMAND
    h, help     show general help
    r, remove   remove package-lock and node_modules
    i, install  clean dependencies and install them from package.json  

OPTIONS:
    -f, --force  force the installation
    --npm        use npm package manager
    --yarn       use yarn package manager
    --pnpm       use pnpm package manager

NOTE: If no package manager is specified, it will auto-detect based on lock files.
"

# Flags
ACTION_FLAG=false
IS_INSTALL_OPTIONAL=false
PACKAGE_MANAGER=""

function printWithColor() {
    TEXT="$1"
    COLOR="$2"
    COLOR_CODE=""

    case $COLOR in
    red) COLOR_CODE=$RED ;;
    cyan) COLOR_CODE=$CYAN ;;
    green) COLOR_CODE=$GREEN ;;
    *) COLOR_CODE=$RESET ;;
    esac

    printf "$COLOR_CODE$TEXT"
}

function checkError() {
    if [[ $ERROR == true ]]; then
        printWithColor "[Error]: Script couldn't run successfully 💥\n" "red"
        exit 1
    fi

    if [ $NPM_ERROR == true ]; then
        printWithColor "[npm Error]: We cannot install NPM dependencies 💥\n" "red"
        exit 1
    fi
}

function detectPackageManager() {
    if [[ -n $PACKAGE_MANAGER ]]; then
        return
    fi
    
    if [[ -f $PNPM_LOCK ]]; then
        PACKAGE_MANAGER="pnpm"
    elif [[ -f $YARN_LOCK ]]; then
        PACKAGE_MANAGER="yarn"
    elif [[ -f $PACKAGE_LOCK ]]; then
        PACKAGE_MANAGER="npm"
    else
        printWithColor "[Error]: No lock file found and no package manager specified. Please use --npm, --yarn, or --pnpm 💥\n" "red"
        exit 1
    fi
}

function removeDependencies() {
    printWithColor "$(date +"%Y-%m-%d %T") Init NPM dependencies removing...⏳\n" "cyan" && sleep 0.5
    printWithColor "$(date +"%Y-%m-%d %T") Moving to $PWD... 🚀\n" "green" && sleep 0.5
    cd $PWD || ERROR=true
    checkError

    if [[ -f $PACKAGE_LOCK ]]; then
        ACTION_FLAG=true
        printWithColor "$(date +"%Y-%m-%d %T") Removing '$PACKAGE_LOCK' file...⚙️\n" "green" && sleep 0.5
        rm $PACKAGE_LOCK || ERROR=true
        checkError

        printWithColor "$(date +"%Y-%m-%d %T") '$PACKAGE_LOCK' file removed! ✅\n" "green" && sleep 0.5
    fi

    if [[ -f $YARN_LOCK ]]; then
        ACTION_FLAG=true
        printWithColor "$(date +"%Y-%m-%d %T") Removing '$YARN_LOCK' file...⚙️\n" "green" && sleep 0.5
        rm $YARN_LOCK || ERROR=true
        checkError

        printWithColor "$(date +"%Y-%m-%d %T") '$YARN_LOCK' file removed! ✅\n" "green" && sleep 0.5
    fi

    if [[ -f $PNPM_LOCK ]]; then
        ACTION_FLAG=true
        printWithColor "$(date +"%Y-%m-%d %T") Removing '$PNPM_LOCK' file...⚙️\n" "green" && sleep 0.5
        rm $PNPM_LOCK || ERROR=true
        checkError

        printWithColor "$(date +"%Y-%m-%d %T") '$PNPM_LOCK' file removed! ✅\n" "green" && sleep 0.5
    fi

    if [[ -d $NODE_MODULES ]]; then
        ACTION_FLAG=true
        printWithColor "$(date +"%Y-%m-%d %T") Removing '$NODE_MODULES' directory...⚙️\n" "green" && sleep 0.5
        rm -rf $NODE_MODULES || ERROR=true
        checkError

        printWithColor "$(date +"%Y-%m-%d %T") '$NODE_MODULES' directory removed! ✅\n" "green" && sleep 0.5
    fi

    if [[ $ACTION_FLAG == false ]]; then
        printWithColor "$(date +"%Y-%m-%d %T") There's nothing to remove! 🗑\n\n" "cyan" && sleep 0.5
    else
        printWithColor "$(date +"%Y-%m-%d %T") Dependencies were removed! ✅\n\n" "cyan" && sleep 0.5
    fi

}

function installDependencies() {
    detectPackageManager
    
    printWithColor "$(date +"%Y-%m-%d %T") Init dependencies installing with $PACKAGE_MANAGER...⏳\n" "cyan" && sleep 0.5
    if [[ -f $PACKAGE ]]; then
        printWithColor "$(date +"%Y-%m-%d %T") Installing dependencies with $PACKAGE_MANAGER...⚙️\n" "green" && sleep 0.5

        case $PACKAGE_MANAGER in
            npm)
                if [[ $IS_INSTALL_OPTIONAL == true ]]; then
                    npm i $OPTION --save || NPM_ERROR=true
                else
                    npm i --save || NPM_ERROR=true
                fi
                ;;
            yarn)
                if [[ $IS_INSTALL_OPTIONAL == true ]]; then
                    yarn add $OPTION || NPM_ERROR=true
                else
                    yarn install || NPM_ERROR=true
                fi
                ;;
            pnpm)
                if [[ $IS_INSTALL_OPTIONAL == true ]]; then
                    pnpm add $OPTION || NPM_ERROR=true
                else
                    pnpm install || NPM_ERROR=true
                fi
                ;;
        esac

        checkError

        printWithColor "$(date +"%Y-%m-%d %T") Dependencies installed with $PACKAGE_MANAGER! ✅\n" "cyan" && sleep 0.5
    else
        printWithColor "$(date +"%Y-%m-%d %T") This directory doesn't have '$PACKAGE' file\n" "cyan" && sleep 0.5
    fi
}

if [[ -z $@ ]] || [[ $# -eq 0 ]]; then
    printWithColor "Empty arguments\n" "red"
    printWithColor "$COMMAND_MAN\n" "cyan"
    exit 1
fi

if [[ $COMMAND == "help" ]] || [[ $COMMAND == "h" ]]; then
    printWithColor "$COMMAND_MAN\n" "cyan"
    exit 1
fi

# Parse package manager options
if [[ $OPTION == "--npm" ]]; then
    PACKAGE_MANAGER="npm"
elif [[ $OPTION == "--yarn" ]]; then
    PACKAGE_MANAGER="yarn"
elif [[ $OPTION == "--pnpm" ]]; then
    PACKAGE_MANAGER="pnpm"
elif [[ -n $OPTION ]] && [[ $OPTION != -* ]]; then
    IS_INSTALL_OPTIONAL=true
fi

if [[ $COMMAND == "remove" ]] || [[ $COMMAND == "r" ]]; then
    removeDependencies
elif
    [[ $COMMAND == "install" ]] || [[ $COMMAND == "i" ]]
then
    removeDependencies
    installDependencies
else
    printWithColor "The command '$COMMAND' isn't correct ❌\n" "red"
    printWithColor "$COMMAND_MAN\n" "cyan"
fi

exit 1
