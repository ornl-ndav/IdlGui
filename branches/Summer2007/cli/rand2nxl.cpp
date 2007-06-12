/** \file rand2nxl.cpp
 *  \brief Creates a nexus light file with random values.
 */

#include "napi.h"
#include <iostream>
#include <string>
#include <cstdlib>
#include <stdexcept>
#include <libgen.h>
#include <tclap/CmdLine.h>

using std::string;
using std::cerr;
using std::endl;
using std::vector;
using std::runtime_error;
using namespace TCLAP;

/** \struct Config
 *  \brief Holds all the configuration variables
 *
 *  The config struct holds all the information obtained
 *  by the command line parser the all the variables can
 *  easily be passed to functions.
 */
struct Config 
{
  string out_path;
  string format;
  int32_t num_events;
  int32_t max_pixel_id;
  int32_t rand_seed;
};

/** \fn void populate_tof(vector<uint32_t> &tof,
 *                        const Config &config);
 *  \brief Creates random time of flight values.
 *  \param tof The vector to fill.
 *  \param config Holds the restraints of the vector, like
 *                the maximum size, and the seed for the
 *                random number generator.
 */
void populate_tof(vector<uint32_t> &tof,
                      const Config &config) 
{
  int i;

  // Set the random number seed
  srand(config.rand_seed);
  for ( i=0; i<config.num_events; i++ ) 
    {
      tof.push_back(rand());
    }
}

/** \fn void populate_pixel_id(vector<uint32_t> &pixel_id,
 *                             const Config &config);
 *  \brief Creates a random vector of pixel id values.
 *  \param pixel_id The vector to fill.
 *  \param config Holds the restraints of the vector, like
 *                the maximum size, maximum pixel value, and 
 *                the seed for the random number generator.
 */
void populate_pixel_id(vector<uint32_t> &pixel_id,
                           const Config &config) 
{
  int i;

  // Set the random number seed
  srand(config.rand_seed);
  for ( i=0; i<config.num_events; i++ ) 
    {
      pixel_id.push_back(rand()%(config.max_pixel_id+1));
    }
}

/** \fn void layout_nexus_file(NXhandle &file_id,
  *                            const Config &config)
  * \brief Creates the nexus file and makes and opens 
  *        the groups.
  * \param file_id The variable to store the nexus file
  *        handle in.
  * \param config Contains the format of the file and the
  *        name of the file.
  */
void layout_nexus_file(NXhandle &file_id,
                       const Config &config) 
{
  NXaccess file_access;

  // Get the format of the nexus file
  if (config.format == "hdf4")
    {
      file_access = NXACC_CREATE4;
    }
  else if (config.format == "xml")
    {
      file_access = NXACC_CREATEXML;
    }
  else
    {
      file_access = NXACC_CREATE5;
    }
 
  // Open the file, make all the groups and close them off
  if (NXopen(config.out_path.c_str(), file_access, &file_id) != NX_OK)
    {
      throw runtime_error("Failed to open nexus file");
    }
  if (NXmakegroup(file_id, "entry", "NXentry") != NX_OK)
    {
      throw runtime_error("Failed to create entry group");
    }
  if (NXopengroup(file_id, "entry", "NXentry") != NX_OK)
    {
      throw runtime_error("Failed to open entry group");
    }
  if (NXmakegroup(file_id, "bank1", "NXevent_data") != NX_OK)
    {
      throw runtime_error("Failed to make NXevent_data group");
    }
  if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group");
    }
  if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group");
    }
}

/** \fn void write_data(const NXhandle &file_id,
  *                     const vector<NumT> &data,
  *                     const string &group_path,
  *                     const string &data_name)
  * \brief Templated function that opens a group
  *        in a nexus file and writes data.
  * \param file_id The handle for the nexus file.
  * \param data Templated vector of data to be 
  *             written.
  * \param group_path The group to write the data
  *                   to in the nexus file.
  * \param data_name The name of the data.
  */
template <typename NumT>
void write_data(const NXhandle &file_id,
                const vector<NumT> &data, 
                const string &group_path,
                const string &data_name)
{
  // Get the size of the data for referencing it
  int size = data.size();

  // Open the group 
  if (NXopengrouppath(file_id, group_path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open group: "+group_path);
    }
  // Make the data, open it, and write it
  if (NXmakedata(file_id, data_name.c_str(), 
             NX_INT32, 1, &size) != NX_OK)
    {
      throw runtime_error("Failed make data: "+data_name);
    }
  if (NXopendata(file_id, data_name.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open data: "+data_name);
    }
  if (NXputdata(file_id, (void *)&data.at(0)) != NX_OK)
    {
      throw runtime_error("Failed to create data");
    }
  // Close the data and the group
  if (NXclosedata(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close data");
    }
  if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group");
    }
}

/** \fn void write_attr(const NXhandle &file_id,
  *                     const string &attr_name,
  *                     const string &attr_value,
  *                     const string &data_path)
  * \brief Opens a data field in a nexus file and
  *        writes an attribute for it.
  * \param file_id The handle for the nexus file.
  * \param attr_name The name of the attribute.
  * \param group_value The value associated with
  *                    the attribute
  * \param data_path The path to the data
  */
void write_attr(const NXhandle &file_id,
                const string &attr_name,
                const string &attr_value,
                const string &data_path)
{
  // Open the data
  if (NXopengrouppath(file_id, data_path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open group: "+data_path);
    }
  // Write the attribute for the data
  if (NXputattr(file_id, (char *)attr_name.c_str(), 
                (char *)attr_value.c_str(), attr_value.length(),
                NX_CHAR) != NX_OK)
    {
      throw runtime_error("Failed to create attribute: "+attr_name);
    }
  // Close the data and the group
  if (NXclosedata(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close data");
    }
  if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group");
    }
}

/** \fn int main(int32_t argc,
 *               char *argv[])
 *  \brief Parses the command line and calls the necessary
 *         functions to make and populate the nexus file.
 */
int main(int32_t argc, 
         char *argv[]) {
  NXhandle file_id;
  struct Config config;
  const string VERSION("1.0");
  vector<uint32_t> rand_tof;
  vector<uint32_t> rand_pixel_id;

  try 
    {
      // Set the default output file name
      string default_file_name(basename(argv[0]));
      default_file_name.append(".nxl");
    
      // Set up the command line object
      CmdLine cmd("", ' ', VERSION);

      // Add command-line options
      ValueArg<string> out_path("o","output",
                       "name of output file (default is <toolname>.nxl)",
                       false, default_file_name, "output file name", cmd);
      
      ValueArg<uint32_t> num_events("", "length", 
                        "number of events to generate (default is 1000)",
                        false, 1000, "number of events", cmd);

      ValueArg<uint32_t> max_pixel_id("", "max_id",
                        "maximum pixel id (default is 10)",
                        false, 10, "max pixel id", cmd);

      ValueArg<uint32_t> rand_seed("", "rand_seed",
                        "seed for random number generator (default is none)",
                        false, 1, "random seed", cmd);

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

      // Fill out the config object
      config.out_path = out_path.getValue();
      config.num_events = num_events.getValue();
      config.max_pixel_id = max_pixel_id.getValue();
      config.rand_seed = rand_seed.getValue();
      config.format = format.getValue();
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  // Populate the random time of flight vector
  populate_tof(rand_tof, config);

  // Populate the random pixel id vector
  populate_pixel_id(rand_pixel_id, config);

  // Open nexus file and layout groups
  layout_nexus_file(file_id, config);

  // Populate the nexus file with information
  write_data(file_id, rand_tof, "/entry/bank1/", "time_of_flight");
  write_data(file_id, rand_pixel_id, "/entry/bank1", "pixel_number");
  write_attr(file_id, "units", "10^-7second", "/entry/bank1/pixel_number");

  // Close the nexus file
  if (NXclose(&file_id) != NX_OK)
    {
      throw runtime_error("Failed to close nexus file");
    }

  return 0;
}
