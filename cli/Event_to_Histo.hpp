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

#include <algorithm>
#include <cmath>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <stdint.h>
#include <string>
#include <tclap/CmdLine.h>
#include <vector>
#include "utils.cpp"

/**
 * \brief This function initializes an array
 * 
 * \param histo_array the array to be initialized
 * \param size the size of the array
 *
 */
void initialize_array(uint32_t * data_histo, 
                      const int32_t size);

/**
 * \brief This function generates the final histogram array
 *
 * \param file_size (INPUT) is the size of the file to be read
 * \param new_Nt (INPUT) is the new number of time bins
 * \param pixel_number (INPUT) is the number of pixelids
 * \param binary_array (INPUT) is the array of values coming from the event
 *  binary file
 * \param histo_array (OUTPUT) is the histogram array
 * \param histo_array_size (INPUT) is the size of the histogram array
 * \param time_bin_vector (INPUT)
 * \param max_time_bin (INPUT)
 * \param debug (INPUT) is a switch that trigger or not the debugging tools
 */
void generate_histo(const int32_t file_size,
                    const int32_t new_Nt,
                    const int32_t pixel_number,
                    const int32_t * binary_array,
                    uint32_t * histo_array,
                    const int32_t histo_array_size,
                    const std::vector<float> time_bin_vector,
                    const float max_time_bin,
                    const bool debug);

/**
 * \brief This function does a binary search of a variable into a given
 * array. It returns the position of the data into the sortedArray or the 
 * closest value inferior to the data. It returns -1 if the data is out of 
 * range.
 *
 * \param sortedVector (INPUT) is the sorted array where to look for the
 * location of the key
 * \param key (INPUT) is the data to look for
 *
 * \returns It returns the position of the data or of the closest inferior value
 * found in sortedVector. Returns -1 if the data is out of range.
*/
int32_t binarySearch(const std::vector<float> sortedVector, 
                     const float key);

/**
 * \brief This function creates the vector of a linear time bins widths
 * For example, for a time bin of 25micros, the first values of the vector
 * will be 0, 25, 50, 75....
 *
 * \param max_time_bin (INPUT) 
 * \param time_rebin_width (INPUT) is the rebin value
 * \param time_offset (INPUT) is the starting offset time
 * \param debug (INPUT) is a switch that trigger or not the debugging tools
 *
 * \return A vector of the time bin values.
 */
vector<float> generate_linear_time_bin_vector(const float max_time_bin,
                                              const int32_t time_rebin_width,
                                              const int32_t time_offset,
                                              const bool debug);


/**
 * \brief This function creates the vector of a logarithmic time bins percentage
 *
 * \param max_time_bin (INPUT)
 * \param log_rebin_percent (INPUT) is the rebin percentage
 * \param time_offset (INPUT) is the starting offset time
 * \param debug (INPUT) is a switch that trigger or not the debugging tools
 *
 * \return A vector of the time bin values.
 */
vector<float> generate_log_time_bin_vector(const float max_time_bin,
                                           const int32_t log_rebin_percent,
                                           const int32_t time_offset,
                                           const bool debug);


#endif // _EVENT_TO_HISTO_HPP
