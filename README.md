Hello chum, welcome to the Splatoon 3 Post Printer guide. First things first, this printer is based on the work of the original contributors shinyquagsire23 and progmem, if you are interested in learning how _they_ did it, follow the forks of this repository and check their README's.

By the end of this guide, you should be able to print your own images in the Splatoon 3 Post and share it to the world. Isn't that great? The Splatoon3 printer is a program that runs in a USB maker board and contains an image that is printed to the Splatoon Post by registering itself as a controller to the switch. When the program starts, it resets the position to the upper left corner and it starts moving across the canvas horizontally until the end of the line is reached. Wherever a dot exists in the image that was provided, the printer will hit the A button to print that same dot in the specified position. the printer will continue to the next line and will finish until all the canvas has been traversed.

Here you can see a sample post from Splatoon 2 that shinyquagsire23 authored and printed.

![http://i.imgur.com/93B1Usb.jpg](http://i.imgur.com/93B1Usb.jpg)
*image via [/u/Stofers](https://www.reddit.com/user/Stofers)*

## Requirements

Please read carefully the expectations of this guide, you will need to gather the following hardware to get your printer going:

1. **A computer** will be necessary to create the software that runs the printer with your image embedded. This guide has instructions for either: 
   * Windows 10, or
   * Mac OSX, or
   * Linux (Fedora or ubuntu were tested)
1. **A USB development board** to work as a controller that automatically prints the post when connected to your Switch console. Select one from the following tested options:
   * Arduino micro, or
   * Arduino Uno, or
   * Teensy 2.0++
1. **A USB-B cable** to plug it to the dev board.
1. **A USB-C adapter** to plug the dev board to the Nintendo Switch.

## Computer One-time Setup

You only require to execute these instructions once in your computer. When you get the printer working, you will not need to do this every time. To change the image flashed into the board, refer to the Image Flashing section below.
   
1. Install the AVR development tools. Follow [this link](https://www.pjrc.com/teensy/gcc.html) where you'll find installers for Windows, Mac and Ubuntu.
   
1. make a folder in your computer to hold this repo and other dependencies you will download later. I will name it ```sp3-print``` and I will reference it through the rest of the guide.
   
1. download and extract this github repository into the sp3-print dir. If you download via the Zip file, make sure that upon extraction, there is not an extra folder generated. i.e. sp3-print/**Splatoon-3-Post-Printer**/Splatoon-3-Post-Printer/. You can avoid that by extracting directly to sp3-print instead of extracting to Splatoon-3-Post-Printer which is the default way this is packaged. *Thanks github, that was super weird.*
   
1. download and extract the [LUFA library](https://github.com/abcminiuser/lufa) github repository into the sp3-print dir. Rename the extracted folder to ```LUFA```

1. make sure [python3 is installed](https://www.python.org/downloads/). The easiest way to figure if you already have it is to open a terminal and type ```python3 --version```, if it yields an error then you must install it.

1. next, you'll get the Pillow imaging library. the command line to install it is:

   ```python3 -m pip install --upgrade pip```
   
   ```python3 -m pip install --upgrade Pillow```
   
   We can verify that python and PIL work by previewing the default post image with _either_ of these steps:
   
   * double click the *checkmypillow* file in the Splatoon-3-Post-Printer folder, 
     OR
   * Execute ```python3 png2c.py -p splatoonpost.png```
   
   You should see a small image coming up in a preview window and that means that python and PIL were correctly installed.

1. download and install [cygwin](https://cygwin.com/install.html) which will be used to compile the printer and the image. The installer is a bit intimidating because it asks for a lot of options but I managed to get it working by not changing anything and hitting next until it asked me no more. That's windows installers in a nutshell, chums.

1. download and install the [arduino IDE](https://www.arduino.cc/en/software). It will ask for drivers to be installed and you have to follow through with those otherwise your computer will not be able to communicate with the board.
1. start the Arduino IDE and plug in your arduino board to the computer and [select the board and port](https://support.arduino.cc/hc/en-us/articles/4406856349970-Select-board-and-port-in-Arduino-IDE) where the arduino is connected. Make a note of the port as it will be required later. If your board is not connecting to the Arduino IDE, check these [troubleshooting instructions](https://support.arduino.cc/hc/en-us/articles/4412955149586-If-your-board-does-not-appear-in-the-port-menu).

### Image Flashing

Your computer should be ready to create a file that the board understands, that is the hex (as in hexadecimal) file. Managing hex files should have a splatoon badge, don't you think? Okay, the hex contains 2 important parts: the printer and the image. Let's get this file ready for the board!

#### Image Requirements and Guidelines

##### Image Size Requirement
An image size of 320 x 120 pixels is the only hard requirement for the image you are about to prepare for the printing. If your image supplied is of a different size, the process will throw an error and will not continue.
a. Size: 320 x 120 pixels

##### Image Guidelines
What makes a good looking image to print? 

1. **A black and white image**. Because the image will be transformed to black and white during the process, the best results are obtained with an image source that is already black and white, even with grayscale you will have tangible differences in the output.
1. **pixel editor**. Can you use an image pixel editor for your content? This way you will control exactly how your image looks. Text and geometric shapes are best drawn this way.
1. **high contrast picture**. One of the nice things about automated printing is to grab any image and put it through the printer. The images that work best are the ones that include high contrast in the colors used. [This is one example](https://twitter.com/benskt_t/status/1569740935369719809).
1. **preview your image prior flashing**. Before putting your board to print the post, you can preview your image in the computer by running the following command: ```python3 png2c.py -p <yourimage.png>``` just replace yourimage.png for the actual filename. jpg and jpeg are also valid file formats here.

#### Image Flashing Procedure
1. place your post.png image in the Splatoon-3-Post-Printer folder. Remember that the size has to be 320x120p.
1. Windows only: start the cygwin terminal and navigate to the Splatoon-3-Post-Printer folder. For reference, your user folder in cygwin starts in ** /cygdrive/Users/<youruser>/**
1. Mac/Linux: in the terminal, go to the Splatoon-3-Post-Printer folder 
1. execute the make command for your board. For example, to prepare the printer and the image for the arduino micro, the following line works:
      
   ```make micro```
   
The other options for the make command are ```teensy``` for the Teensy 2.0++ and ```uno``` for the arduino uno. 
  
A new file with a hex extension should be created and now we need to transfer it to the board. This is a time-sensitive two-step process, but I'm sure you'll get the hang of it. Please make sure to read this instruction until the end of the section before executing it. 

1. with your board connected to the computer, press the reset button in the board and in less than 7 seconds do the following:
  
  * Linux/Mac: run the terminal command
  
   ```./avrdude-flash```
  
  * Windows: Right click on the winavrdude-flash.bat and execute as administrator 

Note: this process can be repeated if the time window is missed. Mac/Linux: It is recommended to have the line already written in the terminal when pressing the reset button to avoid delays. If you press reset and execute the line immediately (less than 1 sec), the command can fail.

If no error was shown in the terminal, you can disconnect your board from the computer and get ready to print on the Switch.

## Printing Splatoon Posts
Once you have executed the image flashing procedure, you need to get to your Nintendo Switch and do the following:

1. Fire up Splatoon 3, in the Square locate the post and press the draw button.
1. Plugin your board to the Nintendo Switch in the USBC port.
1. Wait for it :) it should reset the canvas, choose the smaller dot tool and navigate to the upper left corner of the canvas to start printing.

Notes: make sure to not touch the controllers or the screen during the printing as the process could be affected. Should that happen, press the reset button on the board to restart the process. Sometimes the dot is not so visible, so the volume is a good way to hear the printer working as it emits a sound when printing black dots. Make sure to have the Nintendo Switch charged as it takes some time to print (half-hour maybe). The printer works best with the switch undocked.

### While you Wait
The printer works by using the smallest size pen and D-pad inputs to plot out each pixel one-by-one. When connected, it will automatically sync with the console, reset the cursor position, clean the canvas and print. In case you see issues with controller conflicts while in docked mode, try using a USB-C to USB-A adapter in handheld mode. In dock mode, changes in the HDMI connection will briefly make the Switch not respond to incoming USB commands, skipping pixels in the printout. These changes may include turning off the TV, or switching the HDMI input. (Switching to the internal tuner will be OK, if this doesn't trigger a change in the HDMI input.)

Each line is printed top to bottom, alternating from left to right and viceversa. Printing currently takes about half an hour.

Optionally, upon completion, the Teensy's LED will begin flashing. On compatible Arduino boards, some combination of the onboard LEDs will flash. On the UNO, for instance, both TX and RX LEDs will flash, however the other LEDs will not. If this functionality is desired, issue `make with-alert` when building the firmware. All pins on both PORTB and PORTD are toggled! Beware of possible interactions with any attached peripherals, say from another project.

This repository has been tested using a Teensy 2.0++, Arduino UNO R3, and Arduino Micro.

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
