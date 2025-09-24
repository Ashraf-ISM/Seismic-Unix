#!/bin/bash
surange<simple.su
suxwigb<simple.su xcur=3 title="Simple" &
sleep 2

sustolt<simple.su cdpmin=1 cdpmax=80 dxcdp=40 vmig=2000 tmig=0.0> stolt.simple.su

suxwigb<stolt.simple.su xcur=3 title='Stolt migration of simple data' &
sleep 2

suspike nspk=4 nt=501 ntr=80 dt=.004 ix1=40 it1=63 ix2=40 it2=175 ix3=40 it3=40 it3=330 ix4=40 it4=420 | sushw key=cdp a=1 b=1 > spike_simple.su
suxwigb<spike_simple.su title="Spike"&

sustolt<spike_simple.su vmig=2000 tmig=0.0 dxcdp=40 cdpmin=1 cdpmax=80>stolt.spike.su

suxwigb<stolt.spike.su title="Stolt Migration after spike" &
sleep 2
#--------------------------------------------------------------#
#--------------Gazdag or Phase shift migration------------#
#--------------------------------------------------------------#
sugazmig<simple.su dx=40 vmig=2000 tmig=0.0>gaz.simple.su
suxwigb<gaz.simple.su title="Gazdag Migration" &
#Migration by phase-shift migration
sumigps<simple.su dx=40 vmig=2000 tmig=0.0>ps.simple.su
suxwigb<ps.simple.su title="Phase Shift Migration" &

#Claerbout finite-difference migration

sumigfd< simple.su dx=40 dz=12 nz=150 vfile=vel.fdmig.simple >fd.simple.su
suxwigb<fd.simple.su title="Claerbout finite-difference migration" &
sleep 2

#Ristow and Ruhl’s Fourier finite-difference migration
sumigffd< simple.su dx=40 dz=12 nz=150 vfile=vel.fdmig.simple >ffd.simple.su
suxwigb<ffd.simple.su xcur=3 title="Ristow and Ruhl’s Fourier finite-difference migration" &
sleep 2
#Stoffa’s split-step migration
sumigsplit< simple.su dx=40 dz=12 nz=150 vfile=vel.fdmig.simple >ss.simple.su
suxwigb<ss.simple.su title="Stoffa’s split-step migration" &
sleep 2
#Gazdag Phase-shift Plus Interpolation migration
sumigpspi< simple.su dx=40 dz=12 nz=150 vfile=vel.fdmig.simple >pspi.simple.su
suxwigb<pspi.simple.su title="Gazdag Phase-shift Plus Interpolation migration" &

#----------------------------------------------------------#
#-------Kirchhoff Migration of zero offset data------------#
#----------------------------------------------------------#
surange<simple.su

#innitially if the data do not have sx and gx then do the following to fix the sx & gx of simple.su dat
mv simple.su simple.orig.su

sushw < simple.orig.su key=sx,gx a=0,0 b=40,40 > simple.su

#For Kirchhoff migration, wee need two main scripts: Rayt2d.simple to generate traveltime tables and Kdmig2d.simple to perform Kirchhoff migration on the simple.su data.
#This will generate the traveltime table file tfile.simple and display a traveltime movie
./Rayt2d.simple
#This performs Kirchhoff migration on simple.su and saves the output as kdmig.simple.su.
./Kdmig2d.simple
xmovie < tfile.simple clip=3 n1=501 n2=80 loop=1 title="Traveltime Table" &
#View the Kirchhoff Migration Output
suximage < kdmig.simple.su title="Kirchhoff Migration Output" &

#working with real data(seismic3.su)
surange < seismic3.su
suximage < seismic3.su perc=99 verbose=1 $ title="Real data " &

#--------------------------------------------------------------#
#--------------Stolt Migration using Stoltmig Script------------#
#--------------------------------------------------------------#
#Run Stoltmig to generate stolt.seis.su:
./Stoltmig
#Convert Stolt-Migrated Data to Depth Section
#Run Suttoz.stolt to generate stolt.depth.seis.su:
./Suttoz.stolt
#To visualize the original, migrated time, and depth sections
suximage < seismic3.su clip=.2 title="Stacked Data" &
suximage < stolt.seis.su clip=.2 title="Stolt Time Section" &
suximage < stolt.depth.seis.su clip=.2 title="Stolt Depth Section" &
#--------------------------------------------------------------#
#--------------Phase-Shift Migration using PSmig Script--------#
#--------------------------------------------------------------#
#Run PSmig to generate ps.seis.su:
./PSmig
#Convert Phase-Shift Migrated Data to Depth Section
#Run Suttoz.psmig to generate ps.depth.seis.su:
./Suttoz.psmig
#View the Phase-Shift Migration Results
suximage < ps.seis.su clip=.2 title="PS Time Section" &
suximage < ps.depth.seis.su clip=.2 title="PS Depth Section" &
