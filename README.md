# GDS_Processing
GDS_Processing is a MATLAB library to enable RF analog integrated-circuit designers to convert and manipulate GDS structures and then export them to Cadence layout without DRC errors. I needed a tool during my PhD to move designs from HFSS to Cadence layout without drawing the designs manually again in Cadence. Refere to the [GDS_Processing.pdf file](https://github.com/zainkhalifa/GDS_Processing/blob/master/GDS_Processing.pdf) for a quick overview. Although, I made this library for this specific application, I have created many general functions for GDS files that you might find useful. 

Note: This library depends on the work of Ulf Griesmann in his [gdsii-toolbox](https://github.com/ulfgri/gdsii-toolbox). My files here includes his work. 

Disclaimer: The library is not professionally written. I wrote it along the way as I needed. So always be aware if I missed anything in my descriptions. Make sure that it is doing what you intend and don't count on me taking care of everything for you !

## How to use
Clone or downlaod the library.
On Windows MATLAB, 
1. install mex compiler by running the file `mingw.mlpkginstall` [here](https://github.com/zainkhalifa/GDS_Processing/blob/master/GDS_Lib/mingw.mlpkginstall) or google it for other methods if you dont have that file.
2. Set path in Matlab to `include all subfolders` in your location of the library. You can do that from `HOME --> Set Path`.
3. Compile the library by running ``makemex.m`` [here](https://github.com/zainkhalifa/GDS_Processing/blob/master/GDS_Lib/gdsii-toolbox-master/makemex.m). You need to do this only once. 

On Linux MATLAB, 
Set path in Matlab to `include all subfolders` in your location of the library. You can do that from `HOME --> Set Path`.

## What can you do with this library
General use:
* Import GDS files from HFSS, Cadence or create your own GDS elements/structures 
* Perform operations such as Merge, Split, Mosaic, find intersections, Math operations (and, or, diff)...etc.
* plot and visualize the designs in Matlab before exporting. 
* Assign layer and data type numbers to your elements - layer mapping. 
* Rename your structures and gds libraries or change properties. 
* Export GDS files.

Specific use:
* Disretize a structure so that all vertices fits in the minimum assigned grid for your technology (minGrid). 
* Make all transitions with horizontal and vertical angles to comply with DRC of your technology. 
* Fix/Distort your structures for minimum width and minimum spacing as needed. This works for RF passives since minor chanages won't affect the EM performance of the design if your features are much les than your minimum wavelength. 
* Generate vias between metals so that they are all between your metal structures. 
* Fill empty spaces in your design by any basic grid block you want so that it can pass density requirements in DRC or leave it open for auto generated fillings in Cadence later on. 
* 
*
