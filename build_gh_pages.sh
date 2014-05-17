#!/bin/bash
middleman build
# absolute urls
sed -i 's/href="\//href="http:\/\/mreq\.github\.io\/wmctile\/build\//g' build/*.html build/**/*.html