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
 * \file cli/Map_Data.cpp
 */

#include "Map_Data.hpp"

using namespace std;
using namespace TCLAP;

const std::string make_mapped_filename(const std::string full_path,
                                       const std::string alt_path,
                                       bool debug)
{
  std::string outfile("");
  if(alt_path != "")
    {
      std::string file = full_path.substr(full_path.rfind('/')+1);
      outfile.append(alt_path);
      outfile.append("/");
      outfile.append(file);
    }
  else
    {
      outfile.append(full_path);
    }

  outfile.insert(outfile.rfind('.'), MAP_FILE_POSTFIX);

  if(debug)
    {
      std::cout << "Output File = " << outfile << std::endl;
    }
  
  return outfile;
}

void make_pixel_map(const std::string mapfile, 
                    const int32_t num_pixels, 
                    std::map<int32_t, int32_t> & pixel_map,
                    bool debug)
{
  // Read in the mapping file
  std::ifstream m_data(mapfile.c_str(), std::ios::binary);
  if(!m_data.is_open())
    {
      throw std::runtime_error("Failed opening mapping file");
    }

  int32_t pm_buffer[num_pixels];
  m_data.read(reinterpret_cast<char *>(pm_buffer), 
              num_pixels*sizeof(pm_buffer));
  m_data.close();
  
  // Create the pixel map
  for(size_t i = 0; i < num_pixels; ++i)
    {
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

void print_data_block(const int32_t size, const int32_t *block)
{
  for(size_t i = 0; i < size; ++i)
    {
      std::cout << i << "\t" << block[i] << std::endl;
    }

  return;
}

void create_mapped_data(const std::string neutronfile, 
                        const std::string mappedfile,
                        const int32_t num_tof_bins,
                        const std::map<int32_t, int32_t> & pixel_map,
                        bool debug)
{
  // Open binary data file
  std::ifstream neutron_data(neutronfile.c_str(), std::ios::binary);
  if(!neutron_data.is_open())
    {
      throw std::runtime_error("Failed opening original binary file");
    }

  // Open mapped binary data file
  std::ofstream mapped_data(mappedfile.c_str(), std::ios::binary);
  if(!mapped_data.is_open())
    {
      throw std::runtime_error("Failed opening mapped binary file");
    }
  
  int32_t data_buffer[num_tof_bins];
  
  // Iterate over the pixel map
  std::map<int32_t, int32_t>::const_iterator iter;
  for(iter = pixel_map.begin(); iter != pixel_map.end(); ++iter)
    {
      if(debug)
        {
          std::cout << "Position: " << iter->second << std::endl;
          std::cout << "Offset  : " ;
          std::cout << iter->second * num_tof_bins * SIZEOF_INT32_T;
          std::cout << std::endl;
        }
      
      // Move to proper read location
      neutron_data.seekg(iter->second*num_tof_bins*SIZEOF_INT32_T, 
                         std::ios::beg);
      // Read data from file
      neutron_data.read(reinterpret_cast<char *>(data_buffer), 
                        num_tof_bins*SIZEOF_INT32_T);
      
      if(debug)
        {
          print_data_block(num_tof_bins, data_buffer);
        }
      
      // Write data to mapped file
      mapped_data.write(reinterpret_cast<char *>(data_buffer), 
                        num_tof_bins*SIZEOF_INT32_T);
    }
}

/**
 * \brief This program takes a binary data file, a mapping file and creates 
 *        a mapped binary data file.
 *
 * This program takes a neutron binary data file, a pixel mapping file and 
 * creates a mapped neutron binary data file. The number of detector pixels 
 * and number of time-of-flight channels must be provided to the program. An 
 * alternate path for the create binary data file can be provided. For usage 
 * of the program do
 * <code>
 * Map_Data -h 
 * </code>
 * or
 * <code>
 * Map_Data --help 
 * </code>
 *
 * \param argc
 * \param **argv
 * 
 * \return An integer status number
 */
int main(int argc, char **argv)
{
  try
    {
      // Setup the command-line parser object
      CmdLine cmd("Command line description message", ' ', VERSION_TAG);

      // Add command-line options
      ValueArg<string> neutronArg("n","neutron",
                                  "Name of neutron binary data file",
                                  true, "duh.dat", "filename", cmd);

      ValueArg<string> mapArg("m", "mapping", "Name of the mapping file", 
                              true, "map.dat", "filename", cmd);

      ValueArg<int> pixelArg("p", "pixel", "Number of detector pixels", true,
                             -1, "# of pixels", cmd);

      ValueArg<int> tofArg("t", "tof", "Number of tof bins", true, -1, 
                           "# of tof bins", cmd);

      SwitchArg debugSwitch("d", "debug", "Flag for debugging program", 
                              false, cmd);

      ValueArg<string> altOutPath("o", "output", 
                                  "Alternate path for output file", 
                                  false, "", "path", cmd);

      // Parse the command-line
      cmd.parse(argc, argv);

      // Create the pixel map
      map<int32_t, int32_t> pixel_map;
      make_pixel_map(mapArg.getValue(), pixelArg.getValue(), pixel_map,
                     debugSwitch.getValue());

      // Create the mapped binary data
      create_mapped_data(neutronArg.getValue(),
                         make_mapped_filename(neutronArg.getValue(),
                                              altOutPath.getValue(),
                                              debugSwitch.getValue()),
                         tofArg.getValue(), pixel_map, 
                         debugSwitch.getValue());
      
    } 
  catch(ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}
