;///////////////////////////////////////////
;SNS OFF SPECULAR ANALYSIS (SOS)
;READ IN A NEXUS FILE AND CONVERT TO QXvsQZ SPACE
;//////////////////////////////////////////

Authors:
	Algorithms: Erik Watkins 
	GUI:        Jean Bilheux (j35@ornl.gov)

Instructions to run this application SOS
________________________________________

A/ TO RUN THE GUI VERSION
1- make sure you have the latest version
   ex:
   > cd ~/SVN/SNS_offpsec/
   > svn update
2- within the SNS_offspec folder, to compile and run the application
   > idl
   > idl> .reset
   > idl> @run_gui
   
B/ TO RUN THE ALGORITHM PART ONLY
1- make sure you have the latest version
   ex:
   > cd ~/SVN/SNS_offpsec/
   > svn update
2- within the SNS_offspec folder, to compile and run the application
   > idl
   > idl> .reset
   > idl> @run_idl
   
C/ TO RUN THE UNIT TESTS
1- make sure you have the latest version
   ex:
   > cd ~/SVN/SNS_offpsec/
   > svn update
2- within the SNS_offspec folder, to compile and run the application
   > idl
   > idl> .reset
   > idl> @run_test_unit

D/ TO BUILD THE DOCUMENTATION
1- within the SNS_offspec folder, simply run
   > idl
   > idl> .reset
   > idl> @run_doc
2- to view the documentation, open with your favorite browser doc/index.html
   