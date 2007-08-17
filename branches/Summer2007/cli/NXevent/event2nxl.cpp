/**
 * \file event2nxl.cpp
 * \brief Creates a nexus light file with a given event file.
 */

#include "event2nxl.hpp"
#include "event_data.hpp"
#include <cstdlib>
#include <fstream>
#include <stdexcept>
#include <libgen.h>
#include <typeinfo>
#include <tclap/CmdLine.h>

using std::string;
using std::cerr;
using std::cout;
using std::endl;
using std::vector;
using std::runtime_error;
using std::type_info;
using namespace TCLAP;

/** 
 * \brief Parses the command line and calls the necessary
 *        functions to make and populate the nexus file.
 * \exception ArgException Thrown when TCLAP parser can't correctly
 *                         parse the command line.
 */
int main(int32_t argc, 
         char * argv[]) {
  struct Config config;
  e_nx_access file_access;

  try 
    {
      // Set the default output file name
      string default_file_name(basename(argv[0]));
      default_file_name.append(".nxl");
    
      // Set up the command line object
      CmdLine cmd("", ' ', VERSION);

      // Add command-line options
      ValueArg<string> out_path("o", "output",
                       "name of output file (default is <toolname>.nxl)",
                       false, default_file_name, "output file name", cmd);
      
      ValueArg<string> event_file("i", "input", 
                       "full name of the neutron event file to read from",
                       false, "", "event file name", cmd);

      ValueArg<string> pulse_file("p", "pulse",
                       "full name of the pulse id file to read from",
                       false, "", "pulse file name", cmd);

      ValueArg<string> mapping_file("m", "mapping",
                       "mapping file for pixel ids",
                       false, "", "mapping file", cmd);

      ValueArg<string> bank_file("b", "bank",
                       "bank configuration file",
                       false, "", "bank file", cmd);
      
      // Types for the nexus file format
      vector<string> allowed_types;
      allowed_types.push_back("hdf4");
      allowed_types.push_back("hdf5");
      ValueArg<string> format("f", "format",
                       "format for the nexus file (default is hdf5)",
                       false, "hdf5", allowed_types, cmd);
     
      // Parse the command-line
      cmd.parse(argc, argv); 
      
      if (!event_file.isSet()) 
        {
          throw runtime_error("Error: Must specify an input file");
        }
      if (!mapping_file.isSet())
        {
          throw runtime_error("Error: Must specify a mapping file");
        }
      if (!bank_file.isSet())
        {
          throw runtime_error("Error: Must specify a bank configuration file");
        }
    
      // Fill out the config object
      config.out_path = out_path.getValue();
      config.event_file = event_file.getValue();
      config.pulse_id_file = pulse_file.getValue();
      config.format = format.getValue();
      config.mapping_file = mapping_file.getValue();
      config.bank_file = bank_file.getValue();
      
      // Get the format of the nexus file
      if (format.getValue() == "hdf4")
        {
          file_access = HDF_FOUR;
        }
      else if (format.getValue() =="hdf5")
        {
          file_access = HDF_FIVE;
        }
      else
        {
          throw runtime_error("Invalid nexus format type: " + format.getValue());
        }
    }
  catch (ArgException & e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
      exit(1);
    }

  // Create a bank of information for the nexus file  
  EventData <uint32_t, uint32_t>event_data;
  
  // Create the pixel map
  event_data.create_pixel_map(config.mapping_file);
 
  // Gather the information from the event file
  if (config.pulse_id_file.empty())
    {
      event_data.read_data(config.event_file, config.bank_file);
    }
  else
    {
      event_data.read_data(config.event_file, config.pulse_id_file, config.bank_file);
    }

  // Create a new nexus utility
  NexusUtil nexus_util(config.out_path, file_access);
  
  // Write the nexus file
  event_data.write_nexus_file(nexus_util);
  
  return 0;
}
