/** Author: Wes Kendall
 *  Date: 06-18-07
 */

#include "napi.h"
#include "NexusUtil.hpp"
#include <tclap/CmdLine.h>
#include <iostream>
#include <string>
#include <vector>
#include <libgen.h>

using std::vector;
using std::cerr;
using std::endl;
using std::string;
using namespace TCLAP;

int main (int argc, char *argv[])
{
  int rank;
  int dimensions;
  int nexus_data_type;  
  uint32_t *tof;
  uint32_t *pixel_id;
  string input_file;

  try
    {
      // Set the default output file name
      string default_file_name(basename(argv[0]));
      default_file_name.append(".nxl");
      
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
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
      exit(1);
    }

  // Create a new nexus utility
  NexusUtil nexus_util(input_file, NXACC_READ);
  
  nexus_util.open_group("entry", "NXentry");
  nexus_util.open_group("bank1", "NXevent_data");

  nexus_util.open_data("time_of_flight");
  nexus_util.get_info(&rank, &dimensions, &nexus_data_type);
  nexus_util.malloc((void **)&tof, rank, &dimensions, nexus_data_type);
  nexus_util.get_data(tof);
  nexus_util.close_data();

  nexus_util.open_data("pixel_number");
  nexus_util.get_info(&rank, &dimensions, &nexus_data_type);
  nexus_util.malloc((void **)&pixel_id, rank, &dimensions, nexus_data_type);
  nexus_util.get_data(pixel_id);
  nexus_util.close_data();

  nexus_util.close_group();
  nexus_util.close_group();
}
