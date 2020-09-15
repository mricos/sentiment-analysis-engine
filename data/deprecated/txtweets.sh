#!/bin/bash
cat biden-trump.json | awk '{print $0; system("sleep .5")}' | nc -l -p 3000

