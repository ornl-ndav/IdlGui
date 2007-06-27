/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file event2nxl.cpp
 *  \brief Creates a nexus light file with a given event file.
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

void layout_nexus_file(NexusUtil &nexus_util,
                       const Config &config) 
{
  nexus_util.make_group("entry", "NXentry");
  nexus_util.open_group("entry", "NXentry");
  nexus_util.make_group("bank1", "NXevent_data");
  nexus_util.open_group("bank1", "NXevent_data");
}

inline int typename_to_nexus_type(const int32_t &val)
{
  return NX_INT32;
}

inline int typename_to_nexus_type(const uint32_t &val)
{
  return NX_UINT32;
} 

template <typename NumT>
void write_data(NexusUtil &nexus_util,
                const vector<NumT> &data, 
                const string &group_path,
                const string &data_name)
{
  // Make a non constant variable to pass to nx function
  // to make sure the original is never changed
  vector<NumT> nx_data(data);
  // Get the size of the data for referencing it
  int dimensions = data.size();
  // Get the nexus data type of the template
  NumT type;
  int nexus_data_type = typename_to_nexus_type(type);
  int i = 0;

  nexus_util.open_path(group_path);
  nexus_util.make_data(data_name, nexus_data_type, 1, &dimensions);
  nexus_util.open_data(data_name);

  // Write all the data to the nexus file
  nexus_util.put_slab(&nx_data[0], &i, &dimensions);
}

void write_attr(NexusUtil &nexus_util,
                const string &attr_name,
                const string &attr_value,
                const string &data_path)
{
  // Make a non const variable for NXputattr
  string nx_attr_value(attr_value);

  nexus_util.open_path(data_path);
  nexus_util.put_attr(attr_name, &nx_attr_value[0], 
                      attr_value.length(), NX_CHAR);
}

/** \fn int main(int32_t argc,
 *               char *argv[])
 *  \brief Parses the command line and calls the necessary
 *         functions to make and populate the nexus file.
 */
int main(int32_t argc, 
         char *argv[]) {
  struct Config config;
  e_nx_access file_access;
  e_data_name nx_data_name;

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
          cerr << "Error: Must specify an input file" << endl;
          exit(1);
        }
    
      // Fill out the config object
      config.out_path = out_path.getValue();
      config.event_file = data_file.getValue()+"_neutron_event.dat";
      config.pulse_id_file = data_file.getValue()+"_pulseid.dat";
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
          throw runtime_error("Invalid nexus format type: "+format.getValue());
        }
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
      exit(1);
    }
  
  EventData <uint32_t>bank_one_data("/entry/bank1");
  
  // Gather the information from the event file
  bank_one_data.read_data(config.event_file);

  // Map the pixel ids if necessary
  if (config.mapping_file != "")
    {
      bank_one_data.map_pixel_ids(config.mapping_file);
    }

  // Create a new nexus utility
  NexusUtil nexus_util(config.out_path, file_access);
  // Open nexus file and layout groups
  layout_nexus_file(nexus_util, config);

  // Populate the nexus file with information
  nx_data_name = TOF;
  bank_one_data.write_data(nexus_util, nx_data_name);
  bank_one_data.write_attr(nexus_util, "units", "10^-7second", nx_data_name);
  //write_data(nexus_util, bank_one_data.get_tof(), "/entry/bank1", "time_of_flight");

  nx_data_name = PIXEL_ID;
  bank_one_data.write_data(nexus_util, nx_data_name);

//  write_attr(nexus_util, "units", "10^-7second", "/entry/bank1/time_of_flight");

  return 0;
}
