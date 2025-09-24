#!/bin/bash

## /**
## * @param INPUT Specify your input SU file
## * @param tmin Minimum Output time
## * @param tmax Maximum Output time
## */

# Input
input=Z.su

suxwigb < $input title="ZVSP RAW DATA" label2="Depth (ft)" label1="Time (s)" perc=99 style=vsp key=gelev &




#clean up
rm *.tmp*
rm *.bin

