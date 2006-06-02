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
#include "utils.cpp"

using std::string;
using std::vector;

// Isolate file_name from path+file_name
void path_input_output_file_names(string & path_file_name,
                                  string & file_name,
                                  string & path,
                                  string & alternate_output_path,
                                  string & output_file_name,
                                  bool debug);

// Generate the name of the output file
void produce_output_file_name(string & filename,
                              string & path,
                              string & alternate_path,
                              string & output_filename,
                              bool debug);

// Isolate path and file_name from command line argument
void parse_input_file_name(string & path_filename,
                           string & filename,
                           string & path,
                           bool debug);

// Initialize Array
void initialize_array(int32_t * data_histo, 
                      const int size);

// create histo binary data array
void generate_histo(const int file_size,
                    const int new_Nt,
                    const int32_t pixel_number,
                    const int32_t time_rebin,
                    const int32_t time_bin,
                    const int32_t * binary_array,
                    const int32_t bin_width,
                    int32_t * histo_array,
                    const bool debug);

#endif // _EVENT_TO_HISTO_HPP
