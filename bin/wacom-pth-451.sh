#! /bin/bash

# Wacom Intous Pro Small PTH-451 xsetwacom Config
#:
#: Usage: ./wacom-pth-451.sh [Options]
#:
#: Options:
#:    --help              Show this message and exit
#:    --initiate          First time run
#:    --reset             Reset tablet to defult modes and buttons
#:    --set-buttons       Set buttons acording to configuration
#:    --switch-display    Cycle between displays
#:    --scroll-mode       Map AbsScrollWheel to 4 button modes.
#:    --area-mode         Switch between fullscreen, and percision modes.
#:    --touch-mode        Enable or Diable Touch on the Tablet
#:
#: Percision Modes of this script is based off the script by David Revoy:
#:       * https://gist.github.com/Deevad/51820854ffd5ea5cd883
#: License: CC-0/Public-Domain/WTFPL (http://www.wtfpl.net/) license
#:

## Measurements
# Enter here the active area of your tablet in cm:
XtabletactiveareaCM=15.9
YtabletactiveareaCM=9.9

## Correction Scalling:
# This setting can enlarge a bit the precision zone. I saw during test a 
# precision zone slightly larger has no impact on control quality, and might 
# feels better.
# 
# default=1 for real precision zone, enlarge=1.5 or reduce=0.8
#
# Tip: If you want the most accurate scale. Use a physical template like a 
#      circle template to draw on the tablet then compair to the one on your
#      screen. If the shape on the monitor matches the shape on the template,
#      then bingo you got it!
correctionscalefactor=1.06

# Alternative Size:
#correctionscalefactor=1.5

## Notify-send icon
# Custom Icon if you want to personalize your notifcations.
tablet_icon="/usr/share/icons/Adwaita/scalable/devices/input-tablet-symbolic.svg"

## Button Shortcuts
# Top three buttons
button1="key +Control_L Alt_L +q -q" # Switch Area Modes
button2="key +Control_L Alt_L +w -w" # Switch Monitor
button3="key +Control_L Alt_L +e -e" # Disable/Enable Touch
#Button 4 is the Scroll Wheel Mode Button
button4="key +Control_L Alt_L +r -r" # Switch Scroll Wheel Mode
# Bottom Three Buttons.
button5="key +Shift_L"
button6="key +Control_L"
button7="key +Alt_L"

## Scroll Wheel Modes
# I Have four set cause I plan on binding it to button in the center of the
# scroll wheel. This button has a light which cycle in 4s.
# Mode 1
scrollwheelmode1="Step Zoom Mode"
scrollwheelup1="key +Shift_L +equal"
scrollwheeldown1="key +minus"
# Mode 2
scrollwheelmode2="Step Rotate Mode"
scrollwheelup2="key +Control_R +Left"
scrollwheeldown2="key +Control_R +Right"
# Mode 3
scrollwheelmode3="Change Hue Mode"
scrollwheelup3="key +Shift_L +q"
scrollwheeldown3="key +Shift_L +w"
# Mode 4
scrollwheelmode4="Layer Select Mode"
scrollwheelup4="key +PgUp"
scrollwheeldown4="key +PgDn"
echo 
# This is specific to a dual monitor setup. To find out what your display names
# are use xrandr. For me my primary display is my external, and my secondary
# display is my laptop.

#Primary Display - For me its my External Monitor
display1="HDMI-1"
#Secondary Display - For me it's my Laptop Montor
display2="LVDS-1"

# You shouldn't need to edit anything below this line for this device.
# ------------------------------------------------------------------------------

# Determine if Tablet is using the Wireless kit or Not. For me this is a
# better method.

if [ $(xsetwacom --list |grep -c "WL") = 5 ]; then
    device="Wacom Intuos Pro S (WL)"
else
    device="Wacom Intuos Pro S"
fi

echo "Setup script for your $device PTH-451"
echo "-----------------------------------------"

tabletstylus="$device Pen stylus"
tableteraser="$device Pen eraser"
tabletcursor="$device Pen cursor"
tabletpad="$device Pad pad"
tablettouch="$device Finger touch"

echo ""
echo "Tablet Information:"
echo "STYLUS: $tabletstylus"
echo "ERASER: $tableteraser"
echo "CURSOR: $tabletcursor"
echo "PAD:    $tabletpad"
echo "TOUCH:  $tablettouch"
echo ""
echo "-----------------------------------------"

## Set default Buttons
set_buttons(){
  echo ""
  echo "Setting Default Buttons for $tabletpad."

  # This is the ture order of the buttons on the Tablet.
  xsetwacom set "$tabletpad" Button 2 "$button1"
  xsetwacom set "$tabletpad" Button 3 "$button2"
  xsetwacom set "$tabletpad" Button 8 "$button3"
  xsetwacom set "$tabletpad" Button 1 "$button4"
  xsetwacom set "$tabletpad" Button 9 "$button5"
  xsetwacom set "$tabletpad" Button 10 "$button6"
  xsetwacom set "$tabletpad" Button 11 "$button7"

  echo ""
  echo "Button 2:  '$button1'"
  echo "Button 3:  '$button2'"
  echo "Button 8:  '$button3'"
  echo "Button 1:  '$button4'"
  echo "Button 9:  '$button5'"
  echo "Button 10: '$button6'"
  echo "Button 11: '$button7'"
  echo ""
  echo "-----------------------------------------"
}

## Tablet Display Mode
tablet_display_mode(){
  ## Dual-Monitor Setup

  # This is set up for my dual-monitor setup. This allows it to detect
  # when my HDMI port is connected and sets the default monitor to map to.

  #NOTE: This will be overwritten by tablet_area_mode() if you Reset or Initiate!!

  if [ $(xrandr | grep -c "$display1 connected primary") = 1 ]; then
    primary="$display1"
    secondary="$display2"
  else
    primary="$display1"
    secondary="$display2"
  fi

  echo ""
  echo "Display Defaults"
  echo "Primary Display:" "$primary"
  echo "Secondary Display:" "$secondary"
  echo ""
  echo "-----------------------------------------"

  if [ -f /tmp/wacomscript-451-display-tokken ]; then
    # This will map the tablet to the Secondary Display.
    echo ""
    echo "Mapping to $secondary"
    echo ""
    echo "-----------------------------------------"

    xsetwacom set "$tabletstylus" MapToOutput "$secondary"
    xsetwacom set "$tableteraser" MapToOutput "$secondary"
    xsetwacom set "$tabletcursor" MapToOutput "$secondary"
    xsetwacom set "$tablettouch"  MapToOutput "$secondary"

    notify-send -i "$tablet_icon" "Tablet Settings" "Mapped to $secondary"
    rm /tmp/wacomscript-451-display-tokken
  else
    # This will map the tablet to the Primary Display.
    echo ""
    echo "Mapping to $primary"
    echo ""
    echo "-----------------------------------------"

    xsetwacom set "$tabletstylus" MapToOutput "$primary"
    xsetwacom set "$tableteraser" MapToOutput "$primary"
    xsetwacom set "$tabletcursor" MapToOutput "$primary"
    xsetwacom set "$tablettouch"  MapToOutput "$primary"

    notify-send -i "$tablet_icon" "Tablet Settings" "Mapped to $primary"
    touch /tmp/wacomscript-451-display-tokken
  fi
}

## Tablet Scroll Mode
tablet_scroll_mode(){
  if [ -f /tmp/wacomscript-451-scroll-tokken-mode2 ]; then
    # This will put the scroll wheel in Mode 2
    echo ""
    echo "Switching Scroll Wheel to $scrollwheelmode2"

    xsetwacom set "$tabletpad" AbsWheelUp   "$scrollwheelup2"
    xsetwacom set "$tabletpad" AbsWheelDown "$scrollwheeldown2"

    echo ""
    echo "AbsWheelUp set to $scrollwheelup2"
    echo "AbsWheelDown set to $scrollwheeldown2"
    echo ""
    echo "-----------------------------------------"

    notify-send -i "$tablet_icon" "Tablet Settings" "Scroll Wheel set to $scrollwheelmode2"
    rm /tmp/wacomscript-451-scroll-tokken-mode2
    touch /tmp/wacomscript-451-scroll-tokken-mode3
  elif [ -f /tmp/wacomscript-451-scroll-tokken-mode3 ]; then
    # This will put the scroll wheel in Mode 3
    echo ""
    echo "Switching Scroll Wheel to $scrollwheelmode3"

    xsetwacom set "$tabletpad" AbsWheelUp "$scrollwheelup3"
    xsetwacom set "$tabletpad" AbsWheelDown "$scrollwheeldown3"

    echo ""
    echo "AbsWheelUp set to $scrollwheelup3"
    echo "AbsWheelDown set to $scrollwheeldown3"
    echo ""
    echo "-----------------------------------------"

    notify-send -i "$tablet_icon" "Tablet Settings" "Scroll Wheel set to $scrollwheelmode3"
    rm /tmp/wacomscript-451-scroll-tokken-mode3
    touch /tmp/wacomscript-451-scroll-tokken-mode4
  elif [ -f /tmp/wacomscript-451-scroll-tokken-mode4 ]; then
    # This will put the scroll wheel in Mode 4
    echo ""
    echo "Swtiching Scroll Wheel to $scrollwheelmode4"

    xsetwacom set "$tabletpad" AbsWheelUp "$scrollwheelup4"
    xsetwacom set "$tabletpad" AbsWheelDown "$scrollwheeldown4"

    echo ""
    echo "AbsWheelUp set to $scrollwheelup4"
    echo "AbsWheelDown set to $scrollwheeldown4"
    echo ""
    echo "-----------------------------------------"

    notify-send -i "$tablet_icon" "Tablet Settings" "Scroll Wheel set to $scrollwheelmode4"
    rm /tmp/wacomscript-451-scroll-tokken-mode4
  else
    # This will put the scroll wheel in Mode 1
    echo "Swtiching Scroll Wheel to $scrollwheelmode1"

    xsetwacom set "$tabletpad" AbsWheelUp "$scrollwheelup1"
    xsetwacom set "$tabletpad" AbsWheelDown "$scrollwheeldown1"

    echo ""
    echo "AbsWheelUp:   $scrollwheelup1"
    echo "AbsWheelDown: $scrollwheeldown1"
    echo ""
    echo "-----------------------------------------"

    notify-send -i "$tablet_icon" "Tablet Settings" "Scroll Wheel set to $scrollwheelmode1"
    touch /tmp/wacomscript-451-scroll-tokken-mode2
  fi
}

## Tablet Area Mode
# This mode will only work on the Primary Display.
tablet_area_mode(){
  # Tablet

  xsetwacom --set "$tabletstylus" ResetArea
  xsetwacom --set "$tableteraser" ResetArea
  fulltabletarea=`xsetwacom get "$tabletstylus" Area | grep "[0-9]\+ [0-9]\+$" -o`
  Xtabletmaxarea=`echo $fulltabletarea | grep "^[0-9]\+" -o`
  Ytabletmaxarea=`echo $fulltabletarea | grep "[0-9]\+$" -o`

  # Screen
  Xscreenpix=$(xrandr --listactivemonitors | grep '0:' | uniq | awk '{print $3}'| cut -d 'x' -f 1 | cut -d '/' -f 1)
  Yscreenpix=$(xrandr --listactivemonitors | grep '0:' | uniq | awk '{print $3}'| cut -d 'x' -f 2 | cut -d '/' -f 1)
  screenPPI=$(xdpyinfo | grep dots | awk '{print $2}' | awk -Fx '{print $1}')
  XscreenPPI=$(bc <<< "scale = 2; $Xscreenpix / $screenPPI")
  YscreenPPI=$(bc <<< "scale = 2; $Yscreenpix / $screenPPI")
  XscreenCM=$(bc <<< "scale = 0; $Xscreenpix * 0.0254")
  YscreenCM=$(bc <<< "scale = 0; $Yscreenpix * 0.0254")

  # Precise Mode + Ratio
  Ytabletmaxarearatiosized=$(bc <<< "scale = 0; $Yscreenpix * $Xtabletmaxarea / $Xscreenpix")
  XtabletactiveareaPIX=$(bc <<< "scale = 0; $XtabletactiveareaCM * $screenPPI / 2.54 * $correctionscalefactor")
  YtabletactiveareaPIX=$(bc <<< "scale = 0; $YtabletactiveareaCM * $screenPPI / 2.54 * $correctionscalefactor")
  XtabletactiveareaPIX=$(bc <<< "scale = 0; ($XtabletactiveareaPIX + 0.5) / 1")
  YtabletactiveareaPIX=$(bc <<< "scale = 0; ($YtabletactiveareaPIX + 0.5) / 1")
  XOffsettabletactiveareaPIX=$(bc <<< "scale = 0; ($Xscreenpix - $XtabletactiveareaPIX) / 2")
  YOffsettabletactiveareaPIX=$(bc <<< "scale = 0; ($Yscreenpix - $YtabletactiveareaPIX) / 2")

  echo ""
  echo "Percision Mode Information:"
  echo "Tablet size (cm) :" "$XtabletactiveareaCM" x "$YtabletactiveareaCM"
  echo "Screen size (px) :" "$Xscreenpix" x "$Yscreenpix"
  echo "Screen size (cm) :" "$XscreenCM" x "$YscreenCM"
  echo "Screen ppi :" "$screenPPI"
  echo "Correction factor :" "$correctionscalefactor"
  echo "Maximum tablet-Area (Wacom unit):" "$Xtabletmaxarea" x "$Ytabletmaxarea"
  echo "Precision-mode area (px):" "$XtabletactiveareaPIX" x "$YtabletactiveareaPIX"
  echo "Precision-mode offset (px):" "$XOffsettabletactiveareaPIX" x "$YOffsettabletactiveareaPIX"
  echo ""
  echo "-----------------------------------------"

  if [ -f /tmp/wacomscript-451-memory-tokken ]; then
    # Here Precision mode; full tablet area in cm are 1:1 on a portion of the screen.
    echo ""
    echo "Precision mode on $primary"
    echo ""
    echo "-----------------------------------------"

    xsetwacom set "$tabletstylus" Area 0 0 "$Xtabletmaxarea" "$Ytabletmaxarea"
    xsetwacom set "$tableteraser" Area 0 0 "$Xtabletmaxarea" "$Ytabletmaxarea"
    xsetwacom set "$tabletstylus" MapToOutput "$XtabletactiveareaPIX"x"$YtabletactiveareaPIX"+"$XOffsettabletactiveareaPIX"+"$YOffsettabletactiveareaPIX"

    notify-send -i "$tablet_icon" "Precision mode" "$XtabletactiveareaPIX x $YtabletactiveareaPIX part-of-screen on $primary"
    rm /tmp/wacomscript-451-memory-tokken
  else
    # Here normal mode; tablet map to Fullscreen with ratio correction
    echo ""
    echo "Full-screen mode with ratio correction on $primary"
    echo ""
    echo "-----------------------------------------"

    xsetwacom set "$tabletstylus" Area 0 0 "$Xtabletmaxarea" "$Ytabletmaxarearatiosized"
    xsetwacom set "$tableteraser" Area 0 0 "$Xtabletmaxarea" "$Ytabletmaxarearatiosized"
    xsetwacom set "$tabletstylus" MapToOutput "$Xscreenpix"x"$Yscreenpix"+0+0

    notify-send -i "$tablet_icon" "Normal mode" "full-screen on $primary"
    touch /tmp/wacomscript-451-memory-tokken
  fi
}

## Enable or Disable Touch
tablet_touch_mode(){
  if [ -f /tmp/wacomscript-451-touch-tokken ]; then
    echo ""
    echo "Disabling Touch on $tablettouch"
    echo ""
    echo "-----------------------------------------"

    xsetwacom set "$tablettouch" Touch "off"

    notify-send -i "$tablet_icon" "Tablet Settings" "Touch Diasbled"
    rm /tmp/wacomscript-451-touch-tokken

  else
    echo ""
    echo "Enabling Touch on $tablettouch"
    echo ""
    echo "-----------------------------------------"

    xsetwacom set "$tablettouch" Touch "on"

    notify-send -i "$tablet_icon" "Tablet Settings" "Touch Enabled"
    touch /tmp/wacomscript-451-touch-tokken
  fi
}

# Error Messages
error_msg(){
  echo >&2 "No commands given. (try running with --help)"
}

## Commandline Processing
case "$1" in
  --help)
      grep '^#:' $0 | cut -d ':' -f 2-50
      exit 0
      ;;
  --initiate)
      set_buttons
      tablet_scroll_mode
      tablet_area_mode
      tablet_touch_mode
      ;;
  --reset)
      set_buttons
      rm -fi /tmp/wacomscript-451*
      tablet_scroll_mode
      tablet_area_mode
      tablet_touch_mode
      ;;
  --set-buttons)
      set_buttons
      ;;
  --switch-display)
      tablet_display_mode
      ;;
  --scroll-mode)
      tablet_scroll_mode
      ;;
  --area-mode)
      tablet_area_mode
      ;;
  --touch-mode)
      tablet_touch_mode
      ;;
  *)
      error_msg
      exit 2
      ;;
esac
