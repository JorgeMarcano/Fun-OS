# FUN OS

### Current instructions
print string 

    prints the string in the terminal, like echo
 
hexdump XXXX YY 

    dumps hexadecimal lines  
    total of YY (hex, 0 padded) lines of 16 bytes starting at address XXXX (hex, 0 padded) 

help

	prints a list of all possible commands
	
regdump

	dumps register data 
	used mostly for debugging
	
clear 

	clears the screen
	
dsk 

    prints a list of all disks available
	
mnt XX 

    Sets a specific disk as the current working disk
	if FAT16, will load boot record and print "detected fat16"
	
ls

	list files and folders in current location
	
cd %s

	change working directory
	

