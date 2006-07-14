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
 * $Id$
 *
 * \file cli/Map_Data.hpp
 */
#ifndef _MAP_DATA_HPP
#define _MAP_DATA_HPP 1

#include <fstream>
#include <iostream>
#include <map>
#include <stdexcept>
#include <stdint.h>
#include <string>
#include <tclap/CmdLine.h>

// This is a string that contains the extra file name tag for the mapped 
// neutron histogram binary data
static const std::string MAP_FILE_POSTFIX("_mapped");

/**
 * \defgroup make_mapped_filename Map_Data::make_mapped_filename
 * \{
 */

/**
 * \brief This function creates an output file name from a given file name.
 * 
 * This function takes a neutron histogram binary data filename and converts
 * it to a mapped neutron histogram binary data filename with _mapped inserted
 * before the file extension.
 *
 * \param full_path (INPUT) is the string containing the path and file name 
 *        of the neutron histogram binary data file
 * \param alt_path (INPUT) is a string containing an alternate path where to 
 *        save the resulting file
 * \param debug (INPUT) is a flag for printing debugging info
 *
 * \return A string containing the filename for the mapped neutron histogram 
 *         binary data 
 */
const std::string make_mapped_filename(const std::string full_path,
                                       const std::string alt_path,
                                       bool debug);
/**
 * \} // end of make_mapped_filename group
 */

/**
 * \defgroup make_pixel_map Map_Data::make_pixel_map
 * \{
 */

/**
 * \brief This function creates a pixel map from a mapping file
 *
 * This function opens a mapping file, reads in the pixel index array and 
 * creates a pixel map from the information. This maps the output positions 
 * with the positions in the binary histogram data file.
 *
 * \param mapfile (INPUT) is the string containing the map filename
 * \param num_pixels (INPUT) is the number of expceted detector pixels
 * \param pixel_map (OUTPUT) is the resulting pixel map
 * \param debug (INPUT) is a flag for printing debugging info
 */
std::map<int32_t, int32_t> make_pixel_map(const std::string mapfile, 
                                          const int32_t num_pixels, 
                                          bool debug);
/**
 * \} // end of make_pixel_map group
 */

/**
 * \defgroup print_data_block Map_Data::print_data_block
 * \{
 */

/**
 * \brief This function prints out the contents of a data block.
 *
 * This function takes a data block and its size and prints out the contents 
 * of the data block.
 *
 * \param size (INPUT) is the size of the data block
 * \param block (INPUT) is the pointer to the data block
 */
void print_data_block(const int32_t size, const uint32_t *block);

/**
 * \} // end of print_data_block group
 */

/**
 * \defgroup create_mapped_data Map_Data::create_mapped_data
 * \{
 */

/**
 * \brief This function creates the mapped binary histogram data file.
 *
 * This function takes in the name of the neutron histogram binary data file, 
 * the name of the mapped neutron histogram binary data file, the number of 
 * time-of-flight pixels and the pixel map and uses that information to create 
 * the appropriately mapped neutron histogram binary data.
 *
 * \param neutronfile (INPUT) is the string containing the neutron histogram 
 *        binary data filename
 * \param mappedfile (INPUT) is the string containing the mapped neutron 
 *        histogram binary data filename
 * \param num_tof_bins (INPUT) is the number of time-of-flight bins
 * \param pixel_map (INPUT) is the pixel map structure
 * \param debug (INPUT) is a flag for printing debugging info
 */
void create_mapped_data(const std::string neutronfile, 
                        const std::string mappedfile,
                        const int32_t num_tof_bins,
                        const std::map<int32_t, int32_t> & pixel_map,
                        bool debug);
/**
 * \} // end of create_mapped_data group
 */


#endif // _MAP_DATA_HPP
