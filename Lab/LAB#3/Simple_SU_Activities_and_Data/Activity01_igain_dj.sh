#! /bin/sh
#File: Activity01_igain_dj.sh
#
#      Run script Activity01_igain_dj.scr to start this script
#      or you can run this script directly
#      Interactive gain processing

# Set messages on
##set -x

#================================================
# User-supplied values

indata=oz14h4.su    # Input file
myperc=95           # perc value

#oz14h4.su data range:
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
#muts     4
#ns       1000
#dt       4000

#================================================

echo " "
echo "  *** INTERACTIVE GAIN TEST ***"
echo " "

# Remove temporary files
rm -f tmp*

#------------------------------------------------
# Get preliminary information: trace(s) to analyze
#------------------------------------------------

# Ask user for display key
echo " "
echo " Select key for trace selection:"
echo " Type  0 for offset  or  1 for trace number (tracr)"
> /dev/tty
read myselect

if [ $myselect = 0 ] ; then

  mykey=offset
  
else

  mykey=tracr
  
fi

echo " "
echo " Supply minimum and maximum key values for dB amplitude display."
echo "   For the best display, use only one to three traces."
echo "   for example:  300  300"
echo "            or:  250  450"
echo "            or: -450 -250"
echo "            "
echo "The data has the following range:        "
echo "48 traces:                               "
echo "Trace number (tracr)    1 48             " 
echo "Offset                  690 11030 ft     "
echo "Trace spacing           220 ft           "
echo "Number of samples (ns)  1000             "
echo "Sampling Interval (dt)  4000 microseconds"
echo "Type your min and max key values         "
> /dev/tty
read mykey1 mykey2

#------------------------------------------------
# Log preliminary information

echo "  *** INTERACTIVE GAIN TEST ***" > tmp4
echo "Input file = $indata   perc = $myperc" >> tmp4
echo "key = $mykey   min value = $mykey1   max value = $mykey2" >> tmp4

#------------------------------------------------
# Show original gather and spectra first
#------------------------------------------------
   
suxwigb < $indata xbox=10 ybox=10 wbox=400 hbox=600 \
          label1=" Time (s)" label2="$mykey" \
          title="Original gather" key=$mykey \
          perc=$myperc verbose=0 &

suwind < $indata key=$mykey min=$mykey1 max=$mykey2 |
suattributes mode=amp |
suop op=db > tmp0

suximage < tmp0 xbox=420 ybox=10 wbox=190 hbox=600 \
           label1=" Time" label2="Amplitude" title="Amplitude" \
           grid1=dot grid2=dot legend=1 units=dB \
           cmap=hsv1 verbose=0 &

suxgraph < tmp0 -geometry 190x600+620+10 \
           label1="Time" label2="Amplitude" \
           title="$mykey $mykey1 $mykey2" grid1=dot grid2=dot \
           nTic2=2 -bg white verbose=0 &

#------------------------------------------------
# Amplitude correction
#------------------------------------------------

new=true  # true = first test
ok=false  # false = continue looping

while [ $ok = false ]
do

  rm -f tmp0  # remove earlier copy of file to be gained

  if [ $new = true ] ; then
    cp $indata tmp0
    echo " -> Original data" >> tmp4
  else
    echo " "
    echo "Enter A to add another gain correction"
    echo "Enter S to start over"
    > /dev/tty
    read choice1

    case $choice1 in
      [sS])
            cp $indata tmp0
            echo " -> Using original data"
            echo " -> Using original data" >> tmp4
            ;;
      [aA])
            cp tmp1 tmp0
            echo " -> Using modified data"
            echo " -> Using modified data" >> tmp4
            ;;
    esac

  fi

  echo " "
  echo "Select Gain Correction Method:"
  echo "  Enter A for automatic gain correction"
 # echo "  Enter B to add an overall bias value"
 # echo "  Enter C to clip data"
  echo "  Enter E to multiply data by exp(t*epow)"
 # echo "  Enter J to use Jon Claerbout values:"
 # echo "                 tpow=2  gpow=.5  qclip=.95"
 # echo "  Enter M to balance by dividing by mean"
  echo "  Enter R to balance data by 1/rms" 
 # echo "  Enter S to scale data"
  echo "  Enter T to multiply data by t^tpow"
  > /dev/tty 
  read choice2

  case $choice2 in
    [aA])
          echo " Supply window length in seconds:"
          > /dev/tty
          read wagc
          echo " -> AGC: window length = $wagc s"
          echo " -> AGC: window length = $wagc s" >> tmp4
          sugain < tmp0 agc=1 wagc=$wagc > tmp1
          ;;
    [eE])
          echo " Supply exponent epow:"
          > /dev/tty
          read epow
          echo " -> Gain function is: A'=A*e^(t*$epow)"
          echo " -> Gain function is: A'=A*e^(t*$epow)" >> tmp4
          sugain < tmp0 epow=$epow > tmp1
          ;;
    [rR])
          echo " -> Balance: divide by rms value"
          echo " -> Balance: divide by rms value" >> tmp4
          sugain < tmp0 pbal=1 > tmp1
          ;;
    [tT])
          echo " Supply exponent tpow:"
          > /dev/tty
          read tpow
          echo " -> Gain function is: A'=A*t^$tpow"
          echo " -> Gain function is: A'=A*t^$tpow" >> tmp4
          sugain < tmp0 tpow=$tpow > tmp1
          ;;
  esac

#------------------------------------------------
# Plot gained data
#------------------------------------------------
   
  suxwigb < tmp1 xbox=420 ybox=10 wbox=400 hbox=600 \
            label1=" Time (s)" label2="$mykey" \
            title="Gain applied" key=$mykey \
            perc=$myperc verbose=0 &
  
  suwind < tmp1 key=$mykey min=$mykey1 max=$mykey2 |
  suattributes mode=amp | 
  suop op=db > tmp2

  suximage < tmp2 xbox=830 ybox=10 wbox=190 hbox=600 \
             label1=" Time" label2="Amplitude" title="Amplitude" \
             grid1=dot grid2=dot legend=1 units=dB \
             cmap=hsv1 verbose=0 &

  suxgraph < tmp2 -geometry 190x600+1030+10 \
             label1="Time" label2="Amplitude" \
             title="$mykey $mykey1 $mykey2" grid1=dot grid2=dot \
             nTic2=2 -bg white verbose=0 &

#------------------------------------------------
# Choose loop or exit
#------------------------------------------------

  echo " "
  echo "Enter 1 for more Amplitude corrections"
  echo "Enter 2 to output gained seismic data and EXIT"
  > /dev/tty
  read choice3

  case $choice3 in
    1)
       ok=false
       ;;
    2)
       cp tmp1 igain.su
       echo " ***  Output data file: igain.su"
       echo " ***  Output data file: igain.su" >> tmp4
       cp tmp4 igain.txt
       echo " ***  Output  log file: igain.txt"
       pause exit
       ok=true
       zap xwigb > tmp3  # decrease screen messages
       zap ximage > tmp3  # decrease screen messages
       zap xgraph > tmp3  # decrease screen messages
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

