#include <cmath>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <sys/stat.h>
#include <vector>
#include <time.h>

// $Id: Event_to_Histo.hpp 27 2006-05-02 17:44:39Z j35 $

typedef int binary_type;

using std::string;
using std::vector;

//to swap from little to big endian
inline void endian_swap(binary_type & x);  

void SwapEndian (int file_size, 
                 binary_type * BinaryArray);

// Initialize Array
void InitializeArray(binary_type  * data_histo, 
                     int Nx, 
                     int Ny,
                     int new_nt);

// Generate the name of the output file
void produce_output_file_name(string & file_name,
                              string & output_file,
                              string & path);

// Generate histogram
void Generate_data_histo(binary_type * data_histo,
                         binary_type * BinaryArray, 
                         int GlobalArraySize, 
                         char type_of_rebining,
                         float rebin_value,
                         int new_Nt);

// Print the help menu
void print_help();

// Get the rebin value
float get_rebin_value(char *argv[]);

// Isolate file_name from path+file_name
void isolate_file_name(string & path_file_name,
                       string & file_name,
                       string & path);
