#!/bin/sh
codepoint=$(printf '%x' "\'$1")
fc-list ":charset=$codepoint"

