#!/usr/bin/bash
pandoc -s --metadata title="420-921-VA Database" --mathjax -c github.css "$1".md -o "$1".html

