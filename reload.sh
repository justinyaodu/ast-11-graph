#!/bin/bash

filename="$(sed 's/\.gc$//g' <<< "$1")"

python3 auto_label.py 12 < "$filename.gc" > "$filename.label" && echo "labeling passed" \
		&& gcc -E -x c -undef "$filename.label" -o "$filename.gv" && echo "gcc passed" \
		&& dot -Tsvg "$filename.gv" > "$filename.svg" && echo "dot passed"
