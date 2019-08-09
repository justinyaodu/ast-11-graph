#!/bin/bash

ls *.gc | entr -c bash reload.sh /_
