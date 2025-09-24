#! /bin/sh
# File: Activity02_ifx_dj.sh
#
#       Run script Activity02_ifx_dj.scr to start this script
#       or you can run this script directly
#       Interactive f-k processing

# Set messages on
##set -x

#================================================
# USER AREA -- SUPPLY VALUES
#------------------------------------------------

# Input seismic file
indata=oz8w.su

#
#The input data has the following data range:
#71 traces:
#tracl    26 96 (26 - 96)
#tracr    26 96 (26 - 96)
#fldr     10008
#tracf    26 96 (26 - 96)
#cdp      33 103 (33 - 103)
#cdpt     1
#trid     1
#nvs      1
#nhs      1
#duse     1
#offset   25 1775 (25 - 1775)
#scalel   1
#scalco   1
#counit   1
#delrt    4
#muts     4
#ns       750
#dt       4000
#

# Display choices
myperc=99       # perc value for seismic plots
plottype=0      # 0 = wiggle plot,  1 = image plot

echo " "
echo "Enter the traces Plot Type:"
echo "0 for wiggle plot"
echo "1 for image plot"
> /dev/tty 
read myselect

if [ $myselect = 0 ] ; then

  plottype=0
  
else

  plottype=1
  
fi


# Processing variables [ Instructions below ]
dx=25  # trace spacing
dt=0.004  # time sample interval

#================================================

# Instructions:
# ------------
# sufilter is a classic multi purpose filter (trapezoid-like filter)
#  
#------------------------------------------------

echo "  ------------------------------------------------------"
echo "                     Frequency Filter Test" 
echo "                     ---------------------"
echo "  From your frequency values, two filters are created --"
echo "      a pass filter and a reject filter."
echo "  When you exit, the following files are output:"
echo "              Frequencies are in  ==>  fx.txt"
echo "         Passed data are in  ==>  fxpass.su"
echo "       Rejected data are in  ==>  fxrejj.su"
echo "  ------------------------------------------------------"

# Remove temporary files
rm -f tmp*

#------------------------------------------------
# Describe temporary files
#------------------------------------------------

# tmp0 = Binary. A copy of the input seismic file
# tmp1 = Binary. Data that is processed, either tmp0 or tmp2
#        tmp1 is a copy of tmp0 if re-processing not wanted
#        tmp1 is a copy of tmp2 if re-processing is wanted
# tmp2 = Binary. Output of "a=0,1,1,0" (pass) frequency filtering
# tmp3 = Binary. Output of "a=1,0,0,1" (reject) frequency  filtering
# tmp4 = ASCII record of dialog for output text file
# tmp5 = ASCII file to reduce "zap" screen messages

#------------------------------------------------
# Supply gain value to t^(power)
#------------------------------------------------

echo " "
echo "Supply gain power value for t^(power)"
echo "For no gain, supply 0"
> /dev/tty 
read tpow

# Copy input data to temporary file; apply gain if requested
sugain < $indata tpow=$tpow > tmp0

# Log input file & gain value
echo "                     Frequency Filter Test" > tmp4
echo "                     ---------------------" >> tmp4
echo "sugain < $indata tpow=$tpow" >> tmp4

#------------------------------------------------
# Plot original gather and spectrum
#------------------------------------------------

if [ $plottype -eq 0 ] ; then
  suxwigb < tmp0 xbox=10 ybox=10 wbox=300 hbox=500 \
            label1=" Time (s)" label2="Offset (m)" \
            title="Original data;  gain = $tpow" key=offset \
            perc=$myperc verbose=0 &
else
  suximage < tmp0 xbox=10 ybox=10 wbox=300 hbox=500 \
             label1=" Time (s)" label2="Offset (m)" \
             title="Original data;  gain = $tpow" \
             perc=$myperc verbose=0 &
fi

# Create frequency spectrum of each trace and normalize
suspecfx < tmp0 dx=$dx dt=$dt | suop op=norm |

suximage   xbox=320 ybox=10 wbox=300 hbox=500 \
           label1=" Frequency (Hz)" label2="Trace Number"\
           title="f-x spectrum, no filter" \
           cmap=hsv2 legend=1 units=Amplitude verbose=0 \
           grid1=dots grid2=dots perc=99 &

#------------------------------------------------
# f-x filter test
#------------------------------------------------

new=true  # true = first test
ok=false  # false = continue looping

while [ $ok = false ]
do

  rm -f tmp1  # remove earlier copy of file to be filtered

  if [ $new = true ] ; then
    echo " ==> First test" >> tmp4
    cp tmp0 tmp1
  else
    echo " "
    echo "Enter A or a to add an f-x filter"
    echo "Enter S or s to start over"
    > /dev/tty
    read choice1

    case $choice1 in
      [sS])
            cp tmp0 tmp1
            echo " ==> Using original data"
            echo " ==> Using original data" >> tmp4
            ;;
      [aA])

            echo " "
            echo "Enter P or p to use Passed data"
            echo "Enter R or r to use Rejected data"
            > /dev/tty
            read choice3

            case $choice3 in
              [pP])
                    echo " "
                    cp tmp2 tmp1
                    echo " ==> Using passed data"
                    echo " ==> Using passed data" >> tmp4
                    ;;
              [rR])
                    echo " "
                    cp tmp3 tmp1
                    echo " ==> Using rejected data"
                    echo " ==> Using rejected data" >> tmp4
                    ;;
            esac

            ;;
    esac

# Remove earlier test of passed and rejected data
    rm -f tmp2
    rm -f tmp3

  fi

#------------------------------------------------
# Get filter frequency values
#------------------------------------------------

  echo " "
  echo "Supply the filter parameters (boundaries)."
  echo "Input: f1,f2,f3,f4    where f1 < f2 < f3 < f4"
  echo "  Example:  10,20,30,40"
  echo "Use commas. Do not use spaces."
  > /dev/tty 
  read freqs
  echo " "
  echo "          Frequencies: $freqs"
  echo "          Frequencies: $freqs" >> tmp4

#------------------------------------------------
# Apply filters, plot seismic data, plot f-x data
#------------------------------------------------

# Apply pass filter
  sufilter < tmp1 dx=$dx dt=$dt f=$freqs amps=0,1,1,0 > tmp2
 
# Plot seismic passed data
  if [ $plottype -eq 0 ] ; then
    suxwigb < tmp2 xbox=10 ybox=10 wbox=300 hbox=500 \
              label1=" Time (s)" label2="Offset (m)" \
              title="After f-x PASS filter" key=offset \
              perc=$myperc verbose=0 &
  else
    suximage < tmp2 xbox=10 ybox=10 wbox=300 hbox=500 \
               label1=" Time (s)" label2="Offset (m)" \
               title="After f-x PASS filter" \
               perc=$myperc verbose=0 &
  fi

# Plot f-x passed data
  suspecfx < tmp2 dx=$dx dt=$dt |
  suximage   xbox=320 ybox=10 wbox=300 hbox=500 \
             label1=" Frequency (Hz)" label2="Trace Number" \
             title="f-x Spectrum after PASS filter" \
             cmap=hsv2 legend=1 units=Amplitude verbose=0 \
             grid1=dots grid2=dots perc=99 &
 
# Apply reject filter
  sufilter < tmp1 dx=$dx dt=$dt f=$freqs amps=1,0,0,1 > tmp3
 
# Plot seismic rejected data
  if [ $plottype -eq 0 ] ; then
    suxwigb < tmp3 xbox=630 ybox=10 wbox=300 hbox=500 \
              label1=" Traveltime (s)" label2="Offset (m)" \
              title="After f-x REJECT filter" key=offset \
              perc=$myperc verbose=0 &
  else
    suximage < tmp3 xbox=630 ybox=10 wbox=300 hbox=500 \
               label1=" Time (s)" label2="Offset (m)" \
               title="After f-x REJECT filter" \
               perc=$myperc verbose=0 &
  fi

# Plot f-k rejected data
  suspecfx < tmp3 dx=$dx dt=$dt |
  suximage   xbox=940 ybox=10 wbox=300 hbox=500 \
             label1=" Frequency (Hz)" label2="Trace Number" \
             title="f-x Spectrum after REJECT filter" \
             cmap=hsv2 legend=1 units=Amplitude verbose=0 \
             grid1=dots grid2=dots perc=99 &

#------------------------------------------------
# More f-x or exit
#------------------------------------------------

  echo " "
  echo "Enter 1 for more f-x filter testing"
  echo "Enter 2 to EXIT"
  > /dev/tty
  read choice2

  case $choice2 in
    1)
       ok=false
       ;;
    2)
       cp tmp2 fxpass.su
       cp tmp3 fxrejj.su
       echo "sufilter < $indata dx=$dx dt=$dt \\" >> tmp4
       echo "            freqs=  amps=" >> tmp4
       echo " "
       echo "Processing log is in  ==>  fx.txt"
       echo "  Passed data are in  ==>  fxpass.su"
       echo "  Passed data are in  ==>  fxpass.su" >> tmp4
       echo "Rejected data are in  ==>  fxrejj.su"
       echo "Rejected data are in  ==>  fxrejj.su" >> tmp4
       cp tmp4 fx.txt
       pause exit
       zap xwigb > tmp5
       zap ximage > tmp5
       ok=true
       ;;
  esac

  new=false  # true = first test

done

#------------------------------------------------
# Exit
#------------------------------------------------

# Remove temporary files
rm -f tmp*

# Exit politely from shell
exit

