# mini_l-compiler
Mini_L is a new coding language defined by this Compiler.

**Requirements**

FOR COMPILATION 
- bolt.cs.ucr.edu
    - OR -
- gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04.1)
- flex version 2.6.4
- bison (GNU) version 3.0.4

FOR EXECUTION   
- bolt.cs.ucr.edu
    - OR -
- gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04.1)

**Examples**
There are couple of example code files included in this repo. They can be used to make compiler parser work.  
**Running the Code**
The code can be run by following the sequence of commands:

    make clean
    make
    ./mini_l *filename*.min > filename.mil   
    /*This performs lexical analysis, Parsing, Semantic Analysis and MIL Code generation on the file containing mini l code in filename.min, and redirects the MIL code output to filename.mil*/
    ./mil_run filename.mil < input.txt
    /*executing the generated MIL code with input provided from input.txt*/


