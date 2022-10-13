Hello chum and welcome to the Splatoon 3 Post Printer guide. First things first, this printer is based on the work of the original contributors shinyquagsire23 and progmem, if you are interested in learning how _they_ did it, follow the forks of this repository and check their README's.

By the end of this guide, you should be able to print your own images in the Splatoon 3 Post and share it to the world. Isn't that great?

## Requirements

Now please read carefully the expectations of this guide, you will need to gather the following hardware to get the printer going:

1. **A computer** will be necessary to create the software that runs the printer with your image embedded. This guide has instructions for either: 
   * Windows 10, or
   * Mac OSX, or
   * Linux (Fedora or ubuntu were tested)
1. **A USB development board** to work as a controller that automatically prints the post when connected to your Switch console. Select one from the following tested options:
   * Arduino micro, or
   * Arduino Uno, or
   * Teensy 2.0++
1. **A USB-B cable** to plug it to the dev board
1. **A USB-C adapter** to plug the dev board to the Nintendo Switch. This won't be necessary if your USB-B cable is a USB-C connector on the other end of the cable.

TODO: HERE

##OSX setup

1. make a folder in your computer to hold this repo and other dependencies you will download later. I'll use sp3-print.
1. cd sp3-print and git clone this repository
1. install the AVR libraries and tools by running:
   * brew install crosspack-avr
1. get the LUFA pack, extract and rename it to LUFA, your sp3-print folder should have 2 dirs: this repo and LUFA.
1. make sure [python3 is installed](https://www.python.org/downloads/macos/)
   * pip3 install Pillow
1. cd Splatoon-3-Post-Printer
1. execute the make command 
1. download and install the [arduino IDE](https://www.arduino.cc/en/software)
1. start the Arduino IDE and enable the checkbox for Show verbose output during: upload.
1. plugin your arduino board to the computer and [select the board and port](https://support.arduino.cc/hc/en-us/articles/4406856349970-Select-board-and-port-in-Arduino-IDE) where the arduino is connected. Make a note of the port as it will be required later.
1. 


### Printing Splatoon Posts
For my own personal use, I repurposed Switch-Fightstick to output a set sequence of inputs to systematically print Splatoon posts. This works by using the smallest size pen and D-pad inputs to plot out each pixel one-by-one.

#### Printing Procedure
Just press L to select the pixel pen and plug in the controller: it will automatically sync with the console, reset the cursor position, clean the canvas and print. In case you see issues with controller conflicts while in docked mode, try using a USB-C to USB-A adapter in handheld mode. In dock mode, changes in the HDMI connection will briefly make the Switch not respond to incoming USB commands, skipping pixels in the printout. These changes may include turning off the TV, or switching the HDMI input. (Switching to the internal tuner will be OK, if this doesn't trigger a change in the HDMI input.)

Each line is printed top to bottom, alternating from left to right and viceversa. Printing currently takes about half an hour.

Optionally, upon completion, the Teensy's LED will begin flashing. On compatible Arduino boards, some combination of the onboard LEDs will flash. On the UNO, for instance, both TX and RX LEDs will flash, however the other LEDs will not. If this functionality is desired, issue `make with-alert` when building the firmware. All pins on both PORTB and PORTD are toggled! Beware of possible interactions with any attached peripherals, say from another project.

This repository has been tested using a Teensy 2.0++, Arduino UNO R3, and Arduino Micro.

#### Compiling and Flashing onto the Teensy 2.0++
Go to the Teensy website and download/install the [Teensy Loader application](https://www.pjrc.com/teensy/loader.html). For Linux, follow their instructions for installing the [GCC Compiler and Tools](https://www.pjrc.com/teensy/gcc.html). For Windows, you will need the [latest AVR toolchain](http://www.atmel.com/tools/atmelavrtoolchainforwindows.aspx) from the Atmel site. See [this issue](https://github.com/LightningStalker/Splatmeme-Printer/issues/10) and [this thread](http://gbatemp.net/threads/how-to-use-shinyquagsires-splatoon-2-post-printer.479497/) on GBAtemp for more information. (Note for Mac users - the AVR MacPack is now called AVR CrossPack. If that does not work, you can try installing `avr-gcc` with `brew`.)

Next, you need to grab the LUFA library. You can download it in a zipped folder at the bottom of [this page](http://www.fourwalledcubicle.com/LUFA.php). Unzip the folder, rename it `LUFA`, and place it where you like. Then, download or clone the contents of this repository onto your computer. Next, you'll need to make sure the `LUFA_PATH` inside of the `makefile` points to the `LUFA` subdirectory inside your `LUFA` directory. My `Switch-Fightstick` directory is in the same directory as my `LUFA` directory, so I set `LUFA_PATH = ../LUFA/LUFA`.

Now you should be ready to rock. Open a terminal window in the `Switch-Fightstick` directory, type `make`, and hit enter to compile. If all goes well, the printout in the terminal will let you know it finished the build! Follow the directions on flashing `Joystick.hex` onto your Teensy, which can be found page where you downloaded the Teensy Loader application.

#### Compiling and Flashing onto the Arduino UNO R3
You will need to set your [Arduino in DFU mode](https://www.arduino.cc/en/Hacking/DFUProgramming8U2), and flash its USB controller. (Note for Mac users - try [brew](https://brew.sh/index_it.html) to install the dfu-programmer with `brew install dfu-programmer`.) Setting an Arduino UNO R3 in DFU mode is quite easy, all you need is a jumper (the boards come with the needed pins in place). Please note that once the board is flashed, you will need to flash it back with the original firmware to make it work again as a standard Arduino. To compile this project you will need the AVR GCC Compiler and Tools. (Again for Mac users - try brew, adding the [osx-cross/avr](osx-cross/avr) repository, all you need to do is to type `brew tap osx-cross/avr` and `brew install avr-gcc`.) Next, you need to grab the LUFA library: download and install it following the steps described for the Teensy 2.0++.

Finally, open a terminal window in the `Switch-Fightstick` directory and compile by typing `make uno`. Follow the [DFU mode directions](https://www.arduino.cc/en/Hacking/DFUProgramming8U2) to flash `Joystick.hex` onto your Arduino UNO R3 and you are done.

#### Compiling and Flashing onto the Arduino Micro
The Arduino Micro is more like the Teensy in that it has a single microcontroller that communicates directly over USB. Most of the steps are the same as those for the Teensy, except do not download Teensy Loader program. The make command changes to `make micro` in order to build it for your board.

Once finished building, start up Arduino IDE. Under `File -> Preferences`, check `Show verbose output during: upload` and pick OK. With the Arduino plugged in and properly selected under `Tools`, upload any sketch. Find the line with `avrdude` and copy the entire `avrdude` command and all options into a terminal, replacing the `.hex` file and path to the location of the `Joystick.hex` created in the previous step. Also make sure the `-P/dev/??` port is the same as what Arduino IDE is currently reporting. Now double tap the reset button on the Arduino and quickly press Enter in the terminal. This may take several tries. You may need to press Enter first and then the reset button or try various timings. Eventually, `avrdude` should report success. Store the `avrdude` command in a text file or somewhere safe since you will need it every time you want to print a new image.

Sometimes, the Arduino will show up under a different port, so you may need to run Arduino IDE again to see the current port of your Micro.

If you ever need to use your Arduino Micro with Arduino IDE again, the process is somewhat similar. Upload your sketch in the usual way and double tap reset button on the Arduino. It may take several tries and various timings, but should eventually be successful.

The Arduino Leonardo is theoretically compatible, but has not been tested. It also has the ATmega32u4, and is layed out somewhat similar to the Micro.

#### Attaching the optional buzzer
A suitable 5V buzzer may be attached to any of the available pins on PORTB or PORTD. When compiled with `make with-alert`, it will begin sounding once printing has finished. See above warning about PORTB and PORTD. Reference section 31 of [the AT90USB1286 datasheet](http://www.atmel.com/images/doc7593.pdf) for maximum current specs.

Pin 6 on the Teensy is already used for the LED and it draws around 3mA when fully lit. It is recommended to connect the buzzer to another pin. Do not bridge pins for more current.

For the Arduino UNO, the easiest place to connect the buzzer is to any pin of JP2, or pins 1, 3, or 4 of ICSP1, next to JP2. Refer to section 29 of [the ATmega16u2 datasheet](http://www.atmel.com/Images/Atmel-7766-8-bit-AVR-ATmega16U4-32U4_Datasheet.pdf) for maximum current specs. Do not bridge pins for more current.

On the Arduino Micro, D0-D3 may be used, or pins 1, 3, or 4 (PORTB) on the ICSP header. Power specs are the same as for the AT90USB1286 used on the Teensy. The TX and RX LEDs are on PORTD and PORTB respectively and draw around 3mA apiece. Do not bridge pins for more current.

#### Using your own image
The image printed depends on `image.c` which is generated with `png2c.py` which takes a 320x120 .png image. `png2c.py` will pack the image to a linear 1bpp array. If the image is not already made up of only black and white pixels, it will be dithered.

In order to run `png2c.py`, you need to [install Python](https://www.python.org/downloads/) (I use Python 2.7). Also, you need to have the [Python Imaging Library](https://pillow.readthedocs.io/en/3.0.0/installation.html) installed ([install pip](https://pip.pypa.io/en/stable/installing/#do-i-need-to-install-pip) if you need to).
Using the supplied sample image, splatoonpattern.png:

```
$ python png2c.py splatoonpattern.png
```
Substitute your own .png image to generate the `image.c` file necessary to print. Just make sure your image is in the `Switch-Fightstick` directory.

To generate an inverted colormap of the image:

```
$ python png2c.py -i splatoonpattern.png
```

#### What the dither?
As previously mentioned, png2c.py will dither the input image if you supply an image that is not already made up of only black and white pixels. Say you want to print this bomb image you created...

![http://imgur.com/r2GoVdD.png](http://imgur.com/r2GoVdD.png)

*image via [vjapolitzer](https://github.com/vjapolitzer)*

...but you want to know what it will look like before committing to printing it in Splatoon. Fret not! You can also preview or save a copy of the bilevel version of your image.

To preview the bilevel image:

```
$ python png2c.py -p yourImage.png
```

To save the bilevel image:

```
$ python png2c.py -s yourImage.png
```

![http://imgur.com/uUOeJ7P.png](http://imgur.com/uUOeJ7P.png)

*image via [vjapolitzer](https://github.com/vjapolitzer)*

Looks good! Time to get printing.

### Sample
![http://i.imgur.com/93B1Usb.jpg](http://i.imgur.com/93B1Usb.jpg)
*image via [/u/Stofers](https://www.reddit.com/user/Stofers)*
