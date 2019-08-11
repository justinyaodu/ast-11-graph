#!/bin/bash

filename="$(sed 's/\.gc$//g' <<< "$1")"

gcc -E -x c -undef "$filename.gc" -o "$filename.gv" && echo "gcc passed" \
		&& python3 smart_label.py 12 < "$filename.gv" > "$filename.label" && echo "labeling passed" \
		&& dot -Tsvg "$filename.label" > "$filename.svg" && echo "dot passed"
