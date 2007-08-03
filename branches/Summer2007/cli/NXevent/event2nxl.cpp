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

void layout_nexus_file(NexusUtil & nexus_util,
                       const Config & config,
                       vector<int> & bank_numbers) 
{
  nexus_util.make_group("entry", "NXentry");
  nexus_util.open_group("entry", "NXentry");
  
  int size = bank_numbers.size();
  for (int i = 0; i < size; i++) 
    {
      nexus_util.make_group("bank" + bank_numbers[i], "NXevent_datsa");
    }
}

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
      
      ValueArg<string> data_file("i", "input", 
                       "basename of data file to read from. example - BSS_60",
                       false, "", "data file basename", cmd);

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
      allowed_types.push_back("xml");
      ValueArg<string> format("f", "format",
                       "format for the nexus file (default is hdf5)",
                       false, "hdf5", allowed_types, cmd);
     
      // Parse the command-line
      cmd.parse(argc, argv); 
      
      if (!data_file.isSet()) 
        {
          throw runtime_error("Error: Must specify an input file");
        }
    
      // Fill out the config object
      config.out_path = out_path.getValue();
      config.event_file = data_file.getValue() + "_neutron_event.dat";
      config.pulse_id_file = data_file.getValue() + "_pulseid.dat";
      config.format = format.getValue();
      config.mapping_file = mapping_file.getValue();
      
      // Get the format of the nexus file
      if (format.getValue() == "hdf4")
        {
          file_access = HDF_FOUR;
        }
      else if (format.getValue() =="hdf5")
        {
          file_access = HDF_FIVE;
        }
      else if (format.getValue() == "xml")
        {
          file_access = XML;
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
  EventData <uint32_t>event_data;
  vector<int> bank_numbers;
  
  // Create the pixel map
  if (config.mapping_file != "")
    {
      event_data.create_pixel_map(config.mapping_file);
    }
 
  // Create the bank map
  event_data.parse_bank_file(config.bank_file);
 
  // Gather the information from the event file
  event_data.read_data(config.event_file, config.pulse_id_file, config.bank_file);

  // Create a new nexus utility
  NexusUtil nexus_util(config.out_path, file_access);

  bank_numbers.push_back(1);  // bank1
  bank_numbers.push_back(2);  // bank2
  bank_numbers.push_back(3);  // bank3
  // Open nexus file and layout groups
  layout_nexus_file(nexus_util, config, bank_numbers);

//  event_data.write_nexus_file(nexus_util, "bank file name");

  return 0;
}
