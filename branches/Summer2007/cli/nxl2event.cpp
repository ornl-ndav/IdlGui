/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file nxl2event.cpp
 *  \brief Takes a nexus file and converts it
 *         back to an event file.
 */

#include "napi.h"
#include "NexusUtil.hpp"
#include <tclap/CmdLine.h>
#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <vector>
#include <libgen.h>

using std::vector;
using std::runtime_error;
using std::ofstream;
using std::cerr;
using std::map;
using std::endl;
using std::string;
using std::ifstream;
using namespace TCLAP;

const size_t BLOCK_SIZE = 1024;

/** \fn map_pixel_ids(const string &mapping_file,
 *                  map<uint32_t, uint32_t> &pixel_id_map)
 *  \brief Takes a mapping file and fills a pixel map. This 
 *         map will be used to convert pixel ids back to
 *         their original value.
 */
void map_pixel_ids(const string &mapping_file,
                   map<uint32_t, uint32_t> &pixel_id_map)
{
  size_t data_size = sizeof(uint32_t);
  uint32_t mapping_index = 0;
  int32_t buffer[BLOCK_SIZE];
  size_t offset = 0;
  size_t i;

  // Open the mapping file
  ifstream file(mapping_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: "+mapping_file);
    }

  // Determine the file and buffer size
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg() / data_size;
  size_t buffer_size = (file_size < BLOCK_SIZE) ? file_size : BLOCK_SIZE;

  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  while(offset < file_size)
    {
      file.seekg(offset * data_size, std::ios::beg);
      file.read(reinterpret_cast<char *>(buffer), buffer_size * data_size);

      // For each mapping index, map the pixel id
      // in the mapping file to that index
      for( i = 0; i < buffer_size; i++ )
        {
          pixel_id_map[*(buffer + i)] = mapping_index;
          mapping_index++;
        }

      offset += buffer_size;

      // Make sure to not read past EOF
      if(offset+BLOCK_SIZE > file_size)
        {
          buffer_size = file_size-offset;
        }
    }

  // Close mapping file
  file.close();
}

/** \fn write_data(const string &output_file, 
 *                 uint32_t *tof,
 *                 uint32_t *pixel_id, 
 *                 int size)
 *  \brief Writes binary data to an ouput file
 *         in the same format as an event file. Maps
 *         the pixels if a mapping file is present.
 */
void write_data(const string &output_file, uint32_t *tof, 
                uint32_t *pixel_id, int size, 
                const string &mapping_file)
{
  bool is_mapped = (mapping_file != "") ? true : false;
  map<uint32_t, uint32_t> pixel_id_map;
  map<uint32_t, uint32_t>::iterator map_end;
  map<uint32_t, uint32_t>::iterator map_iterator;

  // Open the event file
  ofstream file(output_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: "+output_file);
    }
 
  // Map the pixels if necessary
  if (is_mapped)
    {
      map_pixel_ids(mapping_file, pixel_id_map);
      map_end = pixel_id_map.end();
    }

  // Write the arrays back in the same way they were read
  for (int i = 0; i < size; i++)
    {
      file.write(reinterpret_cast<char *>(tof+i), 
                 sizeof(uint32_t));
      // Map the pixel back to original value if necessary
      if (is_mapped &&
         (map_iterator = pixel_id_map.find(*(pixel_id + i))) != map_end)
        {
          file.write(reinterpret_cast<char *>(&(map_iterator->second)),
                     sizeof(uint32_t));
        }
      else 
        {
          file.write(reinterpret_cast<char *>(pixel_id+i), 
                     sizeof(uint32_t));
        }
    }

  // Close the event file
  file.close();
}

/** \fn close_bank(NexusUtil &nexus_util)
 *  \brief Closes a bank in a nexus file.
 */
void close_bank(NexusUtil &nexus_util)
{
  nexus_util.close_group();
  nexus_util.close_group();
}

/** \fn get_data(const string &data_name,
 *               void *data,
 *               NexusUtil &nexus_util,
 *               int &dimensions)
 *  \brief Gets data from a nexus file and stores
 *         it into an array.
 *  \return A pointer to the newly allocated array.
 */
void * get_data(const string &data_name, void *data, 
                NexusUtil &nexus_util, int &dimensions)
{
  int rank;
  int nexus_data_type;

  nexus_util.open_data(data_name.c_str());
  nexus_util.get_info(&rank, &dimensions, &nexus_data_type);
  nexus_util.malloc(reinterpret_cast<void **>(&data), rank, 
                    &dimensions, nexus_data_type);
  nexus_util.get_data(data);
  nexus_util.close_data();

  // Return the newly allocated memory for freeing it later
  return data;
}

/** \fn open_bank(const string &bank_name, 
 *                NexusUtil &nexus_util
 *  \brief Opens a bank in a nexus file.
 */
void open_bank(const string &bank_name, NexusUtil &nexus_util)
{
  nexus_util.open_group("entry", "NXentry");
  nexus_util.open_group(bank_name.c_str(), "NXevent_data");
}

/* \fn main(int argc,
 *          char *argv[])
 * \brief Parses the command line and calls the 
 *        appropriate functions.
 */
int main(int argc, char *argv[])
{
  uint32_t *tof;
  uint32_t *pixel_id;
  string input_file;
  string mapping_file;
  string output_file;
  int dimensions;

  try
    {
      // Set the default output file name
      string default_file_name(basename(argv[0]));
      default_file_name.append(".dat");
      
      // Set up the command line object
      CmdLine cmd("", ' ', "1.0");

      ValueArg<string> out_path("o", "output",
                       "name of output file (default is <toolname>.nxl)",
                       false, default_file_name, "output file name", cmd);

      ValueArg<string> nexus_file("i", "input",
                       "nexus file to read from",
                       false, "", "nexus file", cmd);

      ValueArg<string> map_file("m", "mapping",
                       "mapping file for pixel ids",
                       false, "", "mapping file", cmd);

      // Types for the nexus file format
      vector<string> allowed_types;
      allowed_types.push_back("hdf4");
      allowed_types.push_back("hdf5");
      allowed_types.push_back("xml");
      ValueArg<string> format("f", "format",
                       "format for the nexus file (default is hdf5)",
                       false, "hdf5", allowed_types, cmd);

      // Parse the command-line
      cmd.parse(argc, argv);

      if (!nexus_file.isSet())
        {
          cerr << "Error: Must specify an input file" << endl;
          exit(1);
        }
      
      input_file = nexus_file.getValue();
      output_file = out_path.getValue();
      mapping_file = map_file.getValue();
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
      exit(1);
    }

  // Create a new nexus utility
  NexusUtil nexus_util(input_file, NXACC_READ);
  
  // Open the bank and gather the data
  open_bank("bank1", nexus_util);

  tof = reinterpret_cast<uint32_t *>
        (get_data("time_of_flight", tof, nexus_util, dimensions));
  pixel_id = reinterpret_cast<uint32_t *>
             (get_data("pixel_number", pixel_id, nexus_util, dimensions));

  close_bank(nexus_util);

  // Write the data to an equivalent event file
  write_data(output_file, tof, pixel_id, dimensions, mapping_file);
  
  // Free any allocated memory
  nexus_util.free(reinterpret_cast<void **>(&tof));
  nexus_util.free(reinterpret_cast<void **>(&pixel_id));
  return 0;
}
