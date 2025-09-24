# !bin/bash


susynlv>data.su \
 #nt=10 dt=2 ft=0.0 \
 #nxs= dxs=25 fxs=0.0 \
 #nxo=240 dxo=25 fxo=-1.5 \
 #ref="2160,0.096"\
 #ref="2210,-0.304"\
 #ref="2250,-0.159"\
 nt=201 dt=0.01 ft=0.0 \
 nxs=201 dxs=0.05 fxs=0.0 \
 nxo=61 dxo=0.05 fxo=-1.5 \
 ref="0.0,0.25;10.0,0.25"\
 ref="0.0,0.35;5.0,0.5;10.0,0.35"\
 ref="0.0,0.75;10.0,1.0"\
 ref="0.0,1.50;10.0,1.5"\
 v00=1.48 dvdz=2.0 verbose=0\
 suimage<data.su perc=99 title="Synthetic data"
suximage<data.su perc=99 title="Synthetic Data Plot" save="synthetic_data_image.xwd"
