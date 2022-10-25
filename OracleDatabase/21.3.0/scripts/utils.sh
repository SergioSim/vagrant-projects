#!/bin/bash

# Utility functions

shopt -s expand_aliases

logger_function()
{
    echo -e "${@}"
}

alias __log_info='logger_function "[${BASH_SOURCE##*/}:${LINENO}]  [INFO]"'
alias __log_error='logger_function "[${BASH_SOURCE##*/}:${LINENO}] [ERROR]"'

export -f logger_function
