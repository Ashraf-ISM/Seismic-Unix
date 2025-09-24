#!/bin/bash

## /**
## * @todo Test BPF and Normalize basd on RMS value and tpow gain
## * @param input SU file to process
## * @param output_bpf output SU file after BPF filter
## * @param bpf Four points of BPF filter
## * @param output_norm output SU file after normalization (RMS whole window operation)
## * @param output_tvg SU file after TimeVaryingGain (
## * @param tpow TVG constant
## * @param final_output Output after all preprocessing workflow in SU format
## */

#input
input=Z_picked.su
output_bpf=Test_Z_picked_bpf.su # output after BPF
output_norm=Test_Z_picked_bpf_norm.su #output after BPF followed RMS Normalization
output_tpow=Test_Z_picked_bpf_tpow.su
output_tvg=Test_Z_picked_bpf_norm_tvg.su #output after BPF followed RMS Normalization followed by TimeVaryingGain

#get tt pick from header
#tt_picks=tt_picks_auto.txt
#gettime pick from header

sugethw < $input key=lagb,gelev,scalel \
	| sed -e 's/scalel=//' -e 's/gelev=//' -e 's/lagb=//'| sed '/^$/d' > tt-header.tmp
awk '{ printf "%4f %2f\n", $1/1000, ($2/(10^($3*-1))) }' tt-header.tmp > tt-header.txt
tt_picks=tt-header.txt

#set parameter
bpf=10,15,80,90 #4 points bandpass specification
tpow=1.5 #multiply data by t^tpow

#bpf
sufilter < $input f=$bpf > $output_bpf

#normalize only by dividing with RMS
sugain < $output_bpf pbal=1 > $output_norm

#run exponential gain only without normalization
sugain < $output_bpf tpow=$tpow > $output_tpow

#run normalization and exponential gain
sugain < $output_norm tpow=$tpow > $output_tvg

#display
nrec=($(wc -l $tt_picks | awk '{print $1}')) #housekeeping, check number of receiver

suxwigb < $input title="Input" perc=99 style=vsp key=gelev \
	label2="Depth (ft)" label1="Time (s)" x1beg=0.0 x1end=2.0 xbox=10 wbox=500 curve=$tt_picks npair=$nrec,1 curvecolor=red &
suxwigb < $output_bpf title="BPF: $bpf" perc=99 style=vsp key=gelev \
	label2="Depth (s)" label1="Time (s)" x1beg=0.0 x1end=2.0 xbox=520 wbox=500 curve=$tt_picks npair=$nrec,1 curvecolor=red &
suxwigb < $output_norm title="BPF: $bpf + Normalize by RMS" perc=99 style=vsp key=gelev \
	label2="Depth (ft)" label1="Time (s)" x1beg=0.0 x1end=2.0 xbox=10 wbox=500 curve=$tt_picks npair=$nrec,1 curvecolor=red &
suxwigb < $output_tpow title="BPF: $bpf + Gain ($tpow)" perc=99 style=vsp key=gelev \
	label2="Depth" label1="Time (s)" x1beg=0.0 x1end=2.0 xbox=520 wbox=500 curve=$tt_picks npair=$nrec,1 curvecolor=red &
suxwigb < $output_tvg title="BPF: $bpf + Normalize by RMS + Gain ($tpow)" perc=99 style=vsp key=gelev \
	label2="Depth" label1="Time (s)" x1beg=0.0 x1end=2.0 xbox=520 wbox=500 curve=$tt_picks npair=$nrec,1 curvecolor=red &

#clean up
rm *.tmp
