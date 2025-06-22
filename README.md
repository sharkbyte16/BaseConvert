
What is BaseConvert?
===================
BaseConvert is a desktop application built with the Lazarus IDE and Free Pascal compiler that provides real-time conversion between different number bases. The application allows users to input numbers in decimal, hexadecimal, octal, or binary format and instantly see the equivalent values in all other supported bases.

The application features a simple GUI with four input fields corresponding to each number base, along with a bit counter that displays the number of bits required to represent the current value.

![alt text](https://github.com/sharkbyte16/BaseConvert/blob/main/images/Screenshot.png?raw=true)

Features
--------
- Real-time conversion with visual input validation feedback 
- Multi-base support: decimal, hexadecimal, octal, and binary bases 
- Bit counter for the current value

Constraints
-----------
BaseConvert only handles unsigned integer coversions with the following sie limits:
- maximal 19 decimal digits
- maximal 16 hexadecimal digits
- maximal 21 octal digits
- maximal 64 binary digits

Build
-----
BaseConvert is developed using the Lazarus IDE 3.6 and Free Pascal compiler. Lazarus applications are designed to work on both Linux and Windows platforms, though it was primarily developed and tested on Linux. To build BaseConvert, open the .lpr file in Lazarus and compile directly.


  



