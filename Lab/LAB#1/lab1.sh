#!/bin/bash
#suplane | suxwigb
suplane | suxwigb &
suplane | suxwigb title="suplane test pattern" label1="time (s)" label2="trace number" &

suplane > junk.su
suxwigb < junk.su title="suplane test pattern" label1="time (s)" label2="trace number" &
# Output in the postscripts format
supswigb < junk.su title="suplane test pattern" label1="time (s)" label2="trace number" > suplane.eps

###
suplane | suspecfx | suxwigb &
#make suplane data, write to a file
suplane > junk.su
#--find the amplitude spectrum
suspecfx < junk.su > junk1.su
#View the output as wiggle traces
suxwigb < junk1.su &

########Lab Activity #1 – Part II: viewing data###############
ls
suxwigb < sonar.su &
suxwigb < seismic.su &
suxwigb < radar.su &
#Image plot 

suximage < sonar.su &

#Grey scale
suximage < sonar.su perc=99 &  
#The perc=99 passes only those items of the 99th percentile and below in amplitude
suximage < sonar.su perc=99 legend=1

#Legend marking
suximage < sonar.su legend=1 & #This will show a grayscale bar.
suximage < sonar.su legend=1 perc=99 &

#Display balancing and display gaining
sunormalize norm=balmed < sonar.su | suximage legend=1
sunormalize norm=balmed < sonar.su | suximage legend=1 perc=99

sunormalize norm=balmed < sonar.su | sunormalize norm=rms | suximage legend=1

sunormalize norm=balmed < sonar.su |sunormalize norm=rms | suximage legend=1 perc=99

suximage < seismic.su wbox=250 hbox=600 cmap=hsv4 clip=3 title="no median" &

sunormalize norm=balmed < seismic.su |suximage wbox=250 hbox=600 cmap=hsv4 clip=3 title="median filtering" & #This result looks bizarre because the traces individually have different median values and consequently have different ranges of amplitudes.
sunormalize norm=balmed < seismic.su | sunormalize norm=rms |suximage wbox=250 hbox=600 cmap=hsv4 clip=3 title="median filtering" &


