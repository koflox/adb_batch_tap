#!/bin/bash

while getopts ":a:h:p:v:c:u:" opt; do
  case $opt in
    a)
	  isAwakeParam=$OPTARG
      ;;
    h)
	  heightPercentageParam=$OPTARG
      ;;
    p)
	  passwordsList=$OPTARG
      ;;
    v)
	  isSinglePasswordParam=$OPTARG
      ;;
    c)
	  coordsList=$OPTARG
      ;;
    u)
	  isSingleCoordParam=$OPTARG
      ;;
  esac
done

isAwake=${isAwakeParam:-0}
heightPercentage=${heightPercentageParam:-88}
IFS=' ' read -r -a passwords <<< "$passwordsList"
isSinglePassword=${isSinglePasswordParam:-0}
IFS=' ' read -r -a coords <<< "$coordsList"
isSingleCoord=${isSingleCoordParam:-0}

screenStatusAwake="mWakefulness=Awake"
lockStatusUnlocked="mHoldingWakeLockSuspendBlocker=true"

devices=`adb devices | tail  -n +2 | cut -f1`

if [ $isAwake == 1 ]; then
	i=0
	for device in $devices; do
		deviceLockStatus=$(adb -s $device shell dumpsys power | grep "mHoldingWakeLockSuspendBlocker=")
		deviceScreenStatus=$(adb -s $device shell dumpsys power | grep "mWakefulness=")

		if [ $isSinglePassword == 1 ]; then
			password=${passwords[0]}
		else 
			password=${passwords[$i]}
		fi
		
		if [ $deviceScreenStatus != $lockStatusUnlocked ] && [ $deviceScreenStatus != $screenStatusAwake ]; then
			( $(adb -s $device shell input keyevent 26 && 
				adb -s $device shell input touchscreen swipe 930 880 930 380 && 
				adb -s $device shell input text $password && 
				adb -s $device shell input keyevent 66) )
		elif [ $deviceScreenStatus != $lockStatusUnlocked ] && [ $deviceScreenStatus == $screenStatusAwake ]; then
			( $(adb -s $device shell input touchscreen swipe 930 880 930 380 && 
				adb -s $device shell input text $password && 
				adb -s $device shell input keyevent 66) )
		fi
		i=$(($i + 1))
	done
fi

i=0
for device in $devices; do
	(
		deviceName=$(adb -s $device shell getprop ro.product.model)
		sizeOutput=$(adb -s $device shell wm size)
		IFS=' ' read -r -a sizeOutputArray <<< "$sizeOutput"

		size="${sizeOutputArray[2]}"
		IFS='x ' read -r -a dimenOutputArray <<< "$size"

		width=${dimenOutputArray[0]}
		height=${dimenOutputArray[1]}
		
		if [ $isSingleCoord == 1 ]; then
			widthIndex=0
			heightIndex=1
		else
			widthIndex=$(($i * 2))
			heightIndex=$(($i * 2 + 1))
		fi
		
		widthPercentage=${coords[$widthIndex]:-0}
		heightPercentage=${coords[$heightIndex]:-0}
		i=$(($i + 1))

		x=$(($width / 100 * $widthPercentage))
		y=$(($height / 100 * $heightPercentage))
		
		echo "$deviceName tap on ($x, $y), screen size is ${width}x${height}"

		$(adb -s $device shell input tap $x $y)
	) &
done