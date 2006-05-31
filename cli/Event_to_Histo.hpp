/*
 *                       Histogramming Tools
 *           A part of the SNS Analysis Software Suite.
 *
 *                  Spallation Neutron Source
 *          Oak Ridge National Laboratory, Oak Ridge TN.
 *
 *
 *                             NOTICE
 *
 * For this software and its associated documentation, permission is granted
 * to reproduce, prepare derivative works, and distribute copies to the public
 * for any purpose and without fee.
 *
 * This material was prepared as an account of work sponsored by an agency of
 * the United States Government.  Neither the United States Government nor the
 * United States Department of Energy, nor any of their employees, makes any
 * warranty, express or implied, or assumes any legal liability or
 * responsibility for the accuracy, completeness, or usefulness of any
 * information, apparatus, product, or process disclosed, or represents that
 * its use would not infringe privately owned rights.
 *
 */

/**
 * $Id: Event_to_Histo.hpp 27 2006-05-02 17:44:39Z j35 $
 *
 * \file Event_to_Histo.hpp
 */

#ifndef _EVENT_TO_HISTO_HPP
#define _EVENT_TO_HISTO_HPP 1

#include <cmath>
#include <fstream>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <sys/stat.h>
#include <tclap/CmdLine.h>
#include <vector>
#include <time.h>
#include <stdint.h>

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


#endif // _EVENT_TO_HISTO_HPP
