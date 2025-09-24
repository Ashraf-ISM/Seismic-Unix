susynlv > data-test.su \
 nt=201 dt=0.02 ft=0.0 \
 nxs=1 dxs=0.25 fxs=0.0 \
 nxo=240 dxo=0.25 fxo=0.0 \

 #nt=201 dt=0.01 ft=0.0 \
 #nxs=201 dxs=0.05 fxs=0.0 \
 #nxo=61 dxo=0.05 fxo=-1.5 \
 ref="0.0,1.48;2.0,1.65;2.16,1.75;2.21,1.8;2.25,1.55" \
 v00=1.65 dvdz=2.0 verbose=0
suximage < data-test.su perc=99 title="Synthetic Data Plot"
