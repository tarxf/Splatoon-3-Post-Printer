avrdude -v -V -patmega32u4 -cavr109 "-PCOM3" -b57600 -D "-Uflash:w:%~dp0\Joystick.hex:i"
pause
