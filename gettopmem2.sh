#!/bin/bash
ps aux | awk '{if (NR>1) print $4, $5, $6, $11}'|awk '{a1[$NF]+=$1} {a2[$NF]+=$3} {a3[$NF]+=$2} END {for(k in a1) printf ("%.2fG %.2fG %.1f%% %s\n",a2[k]/1024/1024,a3[k]/1024/1024,a1[k],k)}'|sort -gr|head -n 5
