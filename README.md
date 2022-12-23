## Computer Networks Project
Determining the Optimal Values of Configuration Parameters in Wireless Networks for Effective Congestion Control using Machine Learning

Group Number - 25

Group Members -

	Abdul Rasheed Mohamed Ali - 106120026

	B S Sivasundar - 106120026

### Project Directory

- awkFiles : This directory contains the .awk files that we used to extract the values of different performance metrics (PDR, Throughput, Average End-To-End Delay, Number of Dropped Packets).
- excelFiles : This directory contains the raw dataset obtained in .ods and .arff formats.
- outputFiles : This directory contains the values of the 4 performance metrics for the 50 iterations of running the wireless network for different values of Window Size + Packet Size.
- pythonCodes : This directory contains the .py files of the implementations of the 4 Machine Learning algorithms used in our project.
- pythonResults : This directory contains the documentations of the results obtained for our project.
- referenceCodes : This directory contains some codes that we used to refer for our project. 
- report : This directory contains the research papers that were used for reference in our project.
- wekaResults : This directory contains the results obtained through the use of Weka tool. This was our intial approach but we ended up shifting to Python.

The implementation of the Wireless Network in ns2 can be found in the tcpRenoWireless.tcl file. 

### Running the NS2 program

1) Make sure you are in the main project directory. 
2) Open the terminal.
3) Type - "ns tcpRenoWireless.tcl" in the terminal without the double quotes. A window should pop up.
4) In the .nam file that opens up, click on the play button (a triangular button) in the right corner to run the file.

Once this is done, a .tr file will be generated in your project directory. This is the trace file for the network that was run.
