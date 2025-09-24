#!/bin/bash

## /**
## * @brief Create FZ Spectrum & FK-Spectrum
## * @param input SU file to analyze
## * @param output_fz Spectrum of Frequency vs Depth in SU format
## * @param output_fk Spectrum of Frequency vs Wavenumber in SU format
## */

#input
input=Z_picked.su
tt_picks=tt_picks_auto.txt
output_fz=Z_picked_fz.su
output_fk=Z_picked_fk.su

#compute fz
suspecfx < $input > $output_fz

#compute fk
suspecfk < $input dx=50 > $output_fk

#display
nrec=($(wc -l $tt_picks | awk '{print $1}'))
suxwigb < $input title=$input perc=99 style=vsp key=gelev \
	curve=$tt_picks  npair=$nrec,1 curvecolor=red label2="Depth" label1="TWT(s)"&

#displayfz
suximage < $output_fz cmap=hsv2 perc=99 legend=1 title='FZ Spectrum' label1='Freq (Hz)' label2='Level Number' &

#displayfk
suximage < $output_fk cmap=hsv2 perc=99 legend=1 title='FK Spectrum' label1='Freq (Hz)' label2='Wavenumber (k)' & 

