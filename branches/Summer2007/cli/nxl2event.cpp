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
#include <vector>
#include <libgen.h>

using std::vector;
using std::runtime_error;
using std::ofstream;
using std::cerr;
using std::endl;
using std::string;
using namespace TCLAP;

void write_data(const string &output_file, uint32_t *tof, 
                uint32_t *pixel_id, int size)
{
  // Open the event file
  ofstream file(output_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: "+output_file);
    }

  // Write the arrays back in the same way they were read
  for (int i = 0; i < size; i++)
    {
      file.write(reinterpret_cast<char *>(tof+i), sizeof(uint32_t));
      file.write(reinterpret_cast<char *>(pixel_id+i), sizeof(uint32_t));
    }
  file.close();
}

void close_bank(NexusUtil &nexus_util)
{
  nexus_util.close_group();
  nexus_util.close_group();
}

void * get_data(const string &data_name, void *data, 
                NexusUtil &nexus_util, int &dimensions)
{
  int rank;
  int nexus_data_type;

  nexus_util.open_data(data_name.c_str());
  nexus_util.get_info(&rank, &dimensions, &nexus_data_type);
  nexus_util.malloc((void **)&data, rank, &dimensions, nexus_data_type);
  nexus_util.get_data(data);
  nexus_util.close_data();

  // Return the newly allocated memory for freeing it later
  return data;
}

void open_bank(const string &bank_name, NexusUtil &nexus_util)
{
  nexus_util.open_group("entry", "NXentry");
  nexus_util.open_group(bank_name.c_str(), "NXevent_data");
}

int main(int argc, char *argv[])
{
  uint32_t *tof;
  uint32_t *pixel_id;
  string input_file;
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
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
      exit(1);
    }

  // Create a new nexus utility
  NexusUtil nexus_util(input_file, NXACC_READ);
  
  // Open the bank and gather all the data
  open_bank("bank1", nexus_util);

  tof = reinterpret_cast<uint32_t *>
        (get_data("time_of_flight", tof, nexus_util, dimensions));
  pixel_id = reinterpret_cast<uint32_t *>
             (get_data("pixel_number", pixel_id, nexus_util, dimensions));

  close_bank(nexus_util);

  // Write the data to an equivalent event file
  write_data(output_file, tof, pixel_id, dimensions);
  
  // Free any allocated memory
  nexus_util.free(reinterpret_cast<void **>(&tof));
  nexus_util.free(reinterpret_cast<void **>(&pixel_id));
  return 0;
}
