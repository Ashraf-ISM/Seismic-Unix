#! /bin/sh
# File: Activity03_ivelan_dj.sh
#       Run script Activity03_ivelan_dj.scr to start this script
#       or run this script directly
#       Interactive Velocity Analysis and NMO Correction

# Set messages on
##set -x

#================================================
# USER AREA -- SUPPLY VALUES
#------------------------------------------------
# CMPs for analysis

cmp1=14  

numCMPs=1

#------------------------------------------------
# File names

indata=oz14hv.su      # SU format
outpicks=vpick.txt  # ASCII file

#The input CMP gather has the following data range:
#48 traces:
#tracl    1 48 (1 - 48)
#tracr    1 48 (1 - 48)
#fldr     10014
#tracf    1 48 (1 - 48)
#cdp      14
#cdpt     1
#trid     1
#nvs      4
#nhs      1
#duse     1
#offset   690 11030 (11030 - 690)
#scalel   1
#scalco   1
#counit   1
#delrt    4
#muts     4 2250 (2250 - 4)
#ns       1000
#dt       4000

# Ask user for display key
echo " "
echo " Supply the plot type:"
echo "   0 for wiggle plot"
echo "   1 for image plot"
> /dev/tty
read ptype

#------------------------------------------------
# display choices

myperc=98       # perc value for plot
plottype=$ptype      # 0 = wiggle plot,  1 = image plot

#------------------------------------------------
# Processing variables

# Semblance variables
nvs=160  # number of velocities
dvs=50   # velocity intervals
fvs=4000 # first velocity

#================================================

# HOW SEMBLANCE (VELAN) VELOCITIES ARE COMPUTED

# Last Vel =  fvs + (( nvs-1 ) * dvs ) = lvs
#     5000 =  500 + ((  99-1 ) * 45  )
#     3900 = 1200 + (( 100-1 ) * 27  )

# Compute last semblance (velan) velocity
lvs=`bc -l << -END
$fvs + (( $nvs - 1 ) * $dvs )
END`

#------------------------------------------------


# FILE DESCRIPTIONS

# tmp0 = binary temp file for input CVS gathers
# tmp1 = binary temp file for output CVS traces
# tmp2 = ASCII temp file for managing picks
# tmp3 = binary temp file for stacked traces
# tmp4 = ASCII temp file for "wc" result (velan)
# tmp5 = ASCII temp file for stripping file name from tmp4 (velan)
# tmp6 = ASCII temp file to avoid screen display of "zap"
# tmp7 = ASCII temp file for picks
# tmp8 = binary temp file for NMO (flattened) section
# panel.$picknow = current CMP windowed from line of CMPs
# picks.$picknow = current CMP picks arranged as "t1 v1"
#                                                "t2 v2"
#                                                 etc.
# par.# (# is a sequential index number; 1, 2, etc.)
#      = current CMP picks arranged as
#        "tnmo=t1,t2,t3,...
#        "vnmo=v1,v2,v3,...
# par.uni.# (# is a sequential index number; 1, 2, etc.)
#      = current CMP picks arranged as
#        "xin=t1,t2,t3,...
#        "yin=v1,v2,v3,...
#        for input to xgraph to display velocity profile
# par.cmp = file of CMP number and sequential index number;
#           for example: "40 1"
#                        "60 2"
#                         etc.
# par.0 = file "par.cmp" re-arranged as
#         "cdp=#,#,#,etc."  NOTE: # in this line is picked CMP
#         "#=1,2,3,etc."    NOTE: # in this line is "#"
# outpicks = concatenation of par.0 and all par.# files.

#================================================

echo " "
echo "  *** INTERACTIVE VELOCITY ANALYSIS ***"
echo " "

#------------------------------------------------
# Remove old files.  Open new files
rm -f panel.* picks.* par.* tmp*

> $outpicks  # Write empty file for final picks
> par.cmp    # Write empty file for recording CMP values

#------------------------------------------------
s# Get ns, dt, first time from seismic file
nt=`sugethw ns < $indata | sed 1q | sed 's/.*ns=//'`
dt=`sugethw dt < $indata | sed 1q | sed 's/.*dt=//'`
ft=`sugethw delrt < $indata | sed 1q | sed 's/.*delrt=//'`

# Convert dt from header value in microseconds
# to seconds for velocity profile plot
dt=`bc -l << -END
  scale=6
  $dt / 1000000
END`

# If "delrt", use it; else use zero
if [ $ft -ne 0 ] ; then
  tstart=`bc -l << -END
    scale=6
    $ft / 1000
  END`
else
  tstart=0.0
fi

#------------------------------------------------

# Initialize "repick" -- for plotting previous picks on velan
repick=1  # 1=false, 0=true

#------------------------------------------------
# BEGIN IVA LOOP
#------------------------------------------------

i=1
while [ $i -le $numCMPs ]
do

# set variable $picknow to current CMP
  eval picknow=\$cmp$i

  if [ $repick -eq 1 ] ; then
    echo " "
    echo "Preparing CMP $i of $numCMPs for Picking "
    echo "Location is CMP $picknow "
  fi

#------------------------------------------------
# Plot CMP (right)
#------------------------------------------------

  suwind < $indata \
           key=cdp min=$picknow max=$picknow > panel.$picknow
  if [ $repick -eq 1 ] ; then
    if [ $plottype -eq 0 ] ; then
      suxwigb < panel.$picknow key=offset xbox=634 ybox=10 wbox=300 hbox=450 \
                title="CMP gather $picknow" \
                label1=" Time (s)" label2="Offset (ft)" key=offset \
                perc=$myperc verbose=0 &
    else
      suximage < panel.$picknow key=offset xbox=634 ybox=10 wbox=300 hbox=450 \
                title="CMP gather $picknow" \
                label1=" Time (s)" \
                perc=$myperc verbose=0 &
    fi
  else
    if [ $plottype -eq 0 ] ; then
      suxwigb < panel.$picknow key=offset xbox=946 ybox=10 wbox=300 hbox=450 \
                title="CMP gather $picknow" \
                label1=" Time (s)" label2="Offset (ft)" key=offset \
                perc=$myperc verbose=0 &
    else
      suximage < panel.$picknow key=offset xbox=946 ybox=10 wbox=300 hbox=450 \
                title="CMP gather $picknow" \
                label1=" Time (s)" \
                perc=$myperc verbose=0 &
    fi
  fi

#------------------------------------------------
# Picking instructions
#------------------------------------------------

  echo " "
  echo "Preparing CMP $i of $numCMPs for Picking "
  echo "Location is CMP $picknow "
  echo "  Start CVS CMP = $k1   End CVS CMP = $k2"
  echo " "
  echo "  Use the semblance plot to pick (t,v) pairs."
  echo "  Type \"s\" when the mouse pointer is where you want a pick."
  echo "  Be sure your picks increase in time."
  echo "  To control velocity interpolation, pick a first value"
  echo "    near zero time and a last value near the last time."
  echo "  Type \"q\" in the semblance plot when you finish picking."

#------------------------------------------------
# Plot semblance (velan) (left)
#------------------------------------------------

# repick: 1=false, 0=true
  if [ $repick -eq 0 ] ; then

#---  ---  ---  ---  ---  ---  ---  ---  ---  ---
# Get the number of picks (number of lines) in tmp7 |
#   Remove blank spaces preceding the line count.
# Remove file name that was returned from "wc".
# Store line count in "npair" to guide line on velan.

    wc -l tmp7 | sed 's/^  *\(.*\)/\1/' > tmp4
    sed 's/tmp7//' < tmp4 > tmp5
    npair=`sort < tmp5`
#---  ---  ---  ---  ---  ---  ---  ---  ---  ---

    suvelan < panel.$picknow nv=$nvs dv=$dvs fv=$fvs |
    suximage xbox=10 ybox=10 wbox=300 hbox=450 perc=99 \
             units="semblance" f2=$fvs d2=$dvs n2tic=5 \
             title="Semblance Plot CMP $picknow" cmap=hsv2 \
             label1=" Time (s)" label2="Velocity (ft/s)" \
             legend=1 units=Semblance verbose=0 gridcolor=black \
             grid1=solid grid2=solid mpicks=picks.$picknow \
             curve=tmp7 npair=$npair curvecolor=white

  else

    suvelan < panel.$picknow nv=$nvs dv=$dvs fv=$fvs |
    suximage xbox=10 ybox=10 wbox=300 hbox=450 perc=99 \
             units="semblance" f2=$fvs d2=$dvs n2tic=5 \
             title="Semblance Plot CMP $picknow" cmap=hsv2 \
             label1=" Time (s)" label2="Velocity (ft/s)" \
             legend=1 units=Semblance verbose=0 gridcolor=black \
             grid1=solid grid2=solid mpicks=picks.$picknow

  fi

#------------------------------------------------
# End first set of plots
#================================================


#------------------------------------------------
# Manage picks (1): Prepare picks for sunmo
#------------------------------------------------

  sort < picks.$picknow -n |
    mkparfile string1=tnmo string2=vnmo > par.$i
  echo "cdp=$picknow" >> tmp2
  cat par.$i >> tmp2

#================================================
# Begin second set of plots
#------------------------------------------------

#------------------------------------------------
# Flattened seismic data (NMO) plot (middle-right)
#------------------------------------------------
 
  sunmo < panel.$picknow par=tmp2 verbose=0 > tmp8
  if [ $plottype -eq 0 ] ; then
    suxwigb < tmp8 xbox=634 ybox=10 wbox=300 hbox=450 \
            title="CMP $picknow after NMO" \
            label1=" Time (s)" label2="Offset (ft)" \
            verbose=0 perc=$myperc key=offset &
  else
    suximage < tmp8 xbox=634 ybox=10 wbox=300 hbox=450 \
            title="CMP $picknow after NMO" \
            label1=" Time (s)" \
            verbose=0 perc=$myperc &
  fi


#------------------------------------------------
# Stack window
#------------------------------------------------

  sustack < tmp8 > tmp9
  

  if [ $plottype -eq 0 ] ; then
      suxwigb < tmp9 xbox=946 ybox=10 wbox=200 hbox=450 \
          title="CMP $picknow stack trace" \
          label1=" Time (s)" d2num=50 key=cdp \
          verbose=0 perc=$myperc &
  else
      suximage < tmp9 xbox=634 ybox=10 wbox=300 hbox=450 \
            title="CMP $picknow stack trace" \
            label1=" Time (s)" \
            verbose=0 perc=$myperc &
fi


#------------------------------------------------
# Repeated Stack window (right)
#------------------------------------------------

  j=1
  while [ $j -le 8 ]
  do
  
# Append stack trace into tmp3 multiple times
    sustack < tmp8 >> tmp3
  
    j=`expr $j + 1`
  done 
  if [ $plottype -eq 0 ] ; then
      suxwigb < tmp3 xbox=946 ybox=10 wbox=200 hbox=450 \
          title="CMP $picknow repeat stack trace" \
          label1=" Time (s)" d2num=50 key=cdp \
          verbose=0 perc=$myperc &
  else
      suximage < tmp3 xbox=634 ybox=10 wbox=300 hbox=450 \
            title="CMP $picknow repeat stack trace" \
            label1=" Time (s)" \
            verbose=0 perc=$myperc &
fi

#------------------------------------------------
# Manage picks (2): Prepare picks for vel profile
#------------------------------------------------

  sed < par.$i '
  s/tnmo/xin/
  s/vnmo/yin/
              ' > par.uni.$i

#------------------------------------------------
# Velocity profile (left)
#------------------------------------------------

  unisam nout=$nt fxout=$tstart dxout=$dt \
         par=par.uni.$i method=mono |
  xgraph n=$nt nplot=1 d1=$dt f1=$tstart x2beg=$fvs x2end=$lvs \
         label1=" Time (s)" label2="Velocity (ft/s)" \
         title="CMP $picknow Stacking Velocity Function" \
         -geometry 300x450+10+10 -bg white style=seismic \
         grid1=solid grid2=solid linecolor=2 linesize=2 marksize=1 mark=0 \
         titleColor=black axesColor=blue &

#------------------------------------------------
# Dialogue with user: re-pick ?
#------------------------------------------------

  echo " "
  echo " t-v PICKS CMP $picknow"
  echo "----------------------"
  cat picks.$picknow
  echo " "
  echo "  Use the velocity profile (left),"
  echo "    the NMO-corrected gather (middle-right),"
  echo "    and the repeated stack trace (right)"
  echo "    to decide whether to re-pick the CMP."
  echo " "
  echo "Picks OK? (y/n) " > /dev/tty
  read response

  rm tmp*

# "n" means re-loop. Otherwise, continue to next CMP.
  case $response in
    n*)
        i=$i
        echo " "
        echo "Repick CMP $picknow. Overlay previous picks."
        repick=0
        cp picks.$picknow tmp7
        ;;
     *)
        echo "$picknow  $i" >> par.cmp
        i=`expr $i + 1`
        repick=1
        echo "-- CLOSING CMP $picknow WINDOWS --"
        zap xwigb > tmp6
        zap ximage > tmp6
        zap xgraph > tmp6
        ;;
  esac

done

#------------------------------------------------
# Create velocity output file
#------------------------------------------------

mkparfile < par.cmp string1=cdp string2=# > par.0

i=0
while [ $i -le $numCMPs ]
do
  sed < par.$i 's/$/ \\/g' >> $outpicks
  i=`expr $i + 1`
done

#------------------------------------------------
# Remove files and exit
#------------------------------------------------
echo " "
echo " The output file of t-v pairs is "$outpicks
pause
rm -f panel.* picks.* par.* tmp*
exit

