# MATLAB interface for Digital Datcom
A set of functions to write datcom input files, run Digital Datcom, read and post-process the output.

**Requires Digital Datcom installed and added to the path of your system.**
Get it from [http://www.holycows.net/datcom/](http://www.holycows.net/datcom/)

*Tip: for a faster, non-interactive execution, comment lines 128 and 130 in your* `datcom.bat` *file.*

Main function is `callDatcom.m` which calls the function `writeDatcomInput.m` to write the input `.dcm` file.
Actually, it writes flight conditions, reference parameters, and wing planform data only.
Input data is a MATLAB struct containing namelists to be written in a `.dcm` file. The output is read with the
`datcomimport` function of the MATLAB Aerospace Toolset and returned as a struct.

Two examples are included:
 * `CL_alpha_W_vs_Mach1.m` showing the variation of the wing lift gradient with Mach number for different wing planforms with thin airfoils
 * `CL_alpha_W_vs_Mach2.m` showing the variation of the wing lift gradient with Mach number for the same wing with different airfoils 
