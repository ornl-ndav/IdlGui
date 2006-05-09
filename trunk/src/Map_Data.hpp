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
 * \file src/Map_Data.hpp
 */

#ifndef _MAP_DATA_HPP
#define _MAP_DATA_HPP 1

#include <fstream>
#include <iostream>
#include <map>
#include <stdint.h>
#include <string>
#include <tclap/CmdLine.h>

// This is a string that contains the extra file name tag for the mapped 
// neutron histogram binary data
const std::string MAP_FILE_POSTFIX("_mapped");

// This is a string that contains the software tag version
const std::string VERSION_TAG = "1.0.0itc2";

/**
 * \brief This function creates an output file name from a given file name.
 * 
 * This function takes a neutron histogram binary data filename and converts
 * it to a mapped neutron histogram binary data filename with _mapped inserted
 * before the file extension.
 *
 * \param full_path (INPUT) is the string containing the path and file name 
 *        of the neutron histogram binary data file
 * \param debug (INPUT) is a flag for printing debugging info
 *
 * \return A string containing the filename for the mapped neutron histogram 
 *         binary data 
 */
const std::string make_mapped_filename(const std::string full_path,
                                       bool debug)
{
  int index = full_path.rfind('.');
  std::string outfile = full_path;
  outfile.insert(index, MAP_FILE_POSTFIX);

  if(debug)
    {
      std::cout << "Output File = " << outfile << std::endl;
    }

  return outfile;
}

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
void make_pixel_map(const std::string mapfile, 
                    const int32_t num_pixels, 
                    std::map<int32_t, int32_t> & pixel_map,
                    bool debug)
{
  // Read in the mapping file
  std::ifstream m_data(mapfile.c_str(), std::ios::binary);

  int32_t pm_buffer[num_pixels];
  m_data.read(reinterpret_cast<char *>(pm_buffer), 
              num_pixels*sizeof(pm_buffer));
  m_data.close();
  
  // Create the pixel map
  for(size_t i = 0; i < num_pixels; ++i)
    {
      // WHICH WAY?
      //pixel_map[i] = pm_buffer[i];
      pixel_map[pm_buffer[i]] = i;
    }
  
  if(debug)
    {
      std::cout << "Pixel Map:" << std::endl;
      std::map<int32_t, int32_t>::iterator iter;
      for(iter = pixel_map.begin(); iter != pixel_map.end(); ++iter)
        {
          std::cout << iter->first << "\t" << iter->second << std::endl;
        }
    }
}

/**
 * \brief This function prints out the contents of a data block.
 *
 * This function takes a data block and its size and prints out the contents 
 * of the data block.
 *
 * \param size (INPUT) is the size of the data block
 * \param block (INPUT) is the pointer to the data block
 */
void print_data_block(const int32_t size, const int32_t *block)
{
  for(size_t i = 0; i < size; ++i)
    {
      std::cout << i << "\t" << block[i] << std::endl;
    }

  return;
}

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
 * \param neutronfile (INPUT) is the string containing the mapped neutron 
 *        histogram binary data filename
 * \param num_tof_bins (INPUT) is the number of time-of-flight bins
 * \param pixel_map (INPUT) is the pixel map structure
 * \param debug (INPUT) is a flag for printing debugging info
 */
void create_mapped_data(const std::string neutronfile, 
                        const std::string mappedfile,
                        const int32_t num_tof_bins,
                        const std::map<int32_t, int32_t> & pixel_map,
                        bool debug)
{
  // Open binary data file
  std::ifstream neutron_data(neutronfile.c_str(), std::ios::binary);
  
  // Open mapped binary data file
  std::ofstream mapped_data(mappedfile.c_str(), std::ios::binary);
  
  int32_t data_buffer[num_tof_bins];
  
  // Iterate over the pixel map
  std::map<int32_t, int32_t>::const_iterator iter;
  for(iter = pixel_map.begin(); iter != pixel_map.end(); ++iter)
    {
      if(debug)
        {
          std::cout << "Position: " << iter->second << std::endl;
          std::cout << "Offset  : " ;
          std::cout << iter->second * num_tof_bins * sizeof(int32_t);
          std::cout << std::endl;
        }
      
      // Move to proper read location
      neutron_data.seekg(iter->second*num_tof_bins*sizeof(int32_t), 
                         std::ios::beg);
      // Read data from file
      neutron_data.read(reinterpret_cast<char *>(data_buffer), 
                        num_tof_bins*sizeof(int32_t));
      
      if(debug)
        {
          print_data_block(num_tof_bins, data_buffer);
        }
      
      // Write data to mapped file
      mapped_data.write(reinterpret_cast<char *>(data_buffer), 
                        num_tof_bins*sizeof(int32_t));
    }
}


#endif // _MAP_DATA_HPP
