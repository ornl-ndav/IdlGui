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

const string make_mapped_filename(const string full_path,
                                  const string alt_path,
                                  bool debug)
{
  string outfile("");
  if(alt_path != "")
    {
      string file = full_path.substr(full_path.rfind('/')+1);
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
      cout << "Output File = " << outfile << endl;
    }
  
  return outfile;
}

map<int32_t, int32_t> make_pixel_map(const string mapfile, 
                                     const int32_t num_pixels, 
                                     bool debug)
{
  // Read in the mapping file: m_data becomes the array of the mapping file
  ifstream m_data(mapfile.c_str(), ios::binary);
  if(!m_data.is_open())
    {
      throw runtime_error("Failed opening mapping file");
    }

  // check the file size
  m_data.seekg(0,ios::end);
  size_t file_size=m_data.tellg();
  
  if(debug)
    {
      cout << "***Info about mapping file***"<<endl;
      cout << "Name of file is: " << mapfile.c_str()<<endl;
      cout << "Size of file is: " << file_size << endl;
      cout << "Number of pixels: " << num_pixels << endl;
      cout << "*****************************"<<endl;
    }

  if(file_size<sizeof(int32_t)*num_pixels)
    {
      throw runtime_error("Requested more pixels than mapping file contains");
    }

  m_data.seekg(0,ios::beg);

  map<int32_t, int32_t> pixel_map;

    int32_t pm_buffer[num_pixels];
  m_data.read(reinterpret_cast<char *>(pm_buffer), 
              num_pixels*sizeof(int32_t));
  m_data.close();

  // Create the pixel map
  for(size_t i = 0; i < num_pixels; ++i)
    {
      pixel_map[pm_buffer[i]] = i;
    }
  
  if(debug)
    {
      cout << "Pixel Map:" << endl;
      map<int32_t, int32_t>::iterator iter;
      for(iter = pixel_map.begin(); iter != pixel_map.end(); ++iter)
        {
          cout << iter->first << "\t" << iter->second << endl;
        }
    }

  return pixel_map;
}

void print_data_block(const int32_t size, const uint32_t *block)
{
  for(size_t i = 0; i < size; ++i)
    {
      cout << i << "\t" << block[i] << endl;
    }

  return;
}

void create_mapped_data(const string neutronfile, 
                        const string mappedfile,
                        const int32_t num_tof_bins,
                        const map<int32_t, int32_t> & pixel_map,
                        bool debug)
{
  // Open binary data file
  ifstream neutron_data(neutronfile.c_str(), ios::binary);
  if(!neutron_data.is_open())
    {
      throw runtime_error("Failed opening original binary file");
    }

  // Open mapped binary data file
  ofstream mapped_data(mappedfile.c_str(), ios::binary);
  if(!mapped_data.is_open())
    {
      throw runtime_error("Failed opening mapped binary file");
    }

  // determine the file size
  neutron_data.seekg(0,ios::end);
  size_t file_size=neutron_data.tellg();
  neutron_data.seekg(0,ios::beg);

  uint32_t data_buffer[num_tof_bins];
  
  // Iterate over the pixel map
  map<int32_t, int32_t>::const_iterator iter;
  for(iter = pixel_map.begin(); iter != pixel_map.end(); ++iter)
    {
      if(debug)
        {
          cout << "Position: " << iter->second << endl;
          cout << "Offset  : " ;
          cout << iter->second * num_tof_bins * SIZEOF_UINT32_T;
          cout << endl;
        }
      
      // Move to proper read location
      neutron_data.seekg(iter->second*num_tof_bins*SIZEOF_UINT32_T, 
                         ios::beg);
      // check that the read won't go past the end of file
      size_t pos=neutron_data.tellg();
      if(pos+num_tof_bins*SIZEOF_UINT32_T>file_size)
        {
          throw runtime_error("Tried to read past end of data file");
        }

      // Read data from file
      neutron_data.read(reinterpret_cast<char *>(data_buffer), 
                        num_tof_bins*SIZEOF_UINT32_T);
      
      if(debug)
        {
          print_data_block(num_tof_bins, data_buffer);
        }
      
      // Write data to mapped file
      mapped_data.write(reinterpret_cast<char *>(data_buffer), 
                        num_tof_bins*SIZEOF_UINT32_T);
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

      ValueArg<int32_t> pixelArg("p", "pixel", "Number of detector pixels", 
                                 true, -1, "# of pixels", cmd);
      
      ValueArg<int32_t> tofArg("t", "tof", "Number of tof bins", true, -1, 
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
      pixel_map = make_pixel_map(mapArg.getValue(), pixelArg.getValue(), 
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
