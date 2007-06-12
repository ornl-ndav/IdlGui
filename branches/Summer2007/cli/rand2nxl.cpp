/** \file rand2nxl.cpp
 *  \brief Creates a nexus light file with random values.
 */

#include "napi.h"
#include <iostream>
#include <string>
#include <cstdlib>
#include <libgen.h>
#include <tclap/CmdLine.h>

using std::string;
using std::cerr;
using std::endl;
using std::vector;
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

/** \fn void populate_tof_arr(int *const tof_arr,
 *                            Config &config);
 *  \brief Creates a random array of time of flight
 *         values.
 *  \param tof_arr The array to fill.
 *  \param config Holds the restraints of the array, like
 *                the maximum size, and the seed for the
 *                random number generator.
 */
void populate_tof_arr(int *const tof_arr,
                      Config &config) 
{
  int i;

  // Set the random number seed
  srand(config.rand_seed);
  for ( i=0; i<config.num_events; i++ ) 
    {
      tof_arr[i] = rand();
    }
}

/** \fn void populate_pixel_id_arr(int *const pixel_id_arr,
 *                                 Config &config);
 *  \brief Creates a random array of time of pixel id
 *         values.
 *  \param pixel_id_arr The array to fill.
 *  \param config Holds the restraints of the array, like
 *                the maximum size, maximum pixel value, and 
 *                the seed for the random number generator.
 */
void populate_pixel_id_arr(int *const pixel_id_arr,
                           Config &config) 
{
  int i;

  // Set the random number seed
  srand(config.rand_seed);
  for ( i=0; i<config.num_events; i++ ) 
    {
      pixel_id_arr[i] = rand()%(config.max_pixel_id+1);
    }
}

/** \fn void layout_nexus_file(NXhandle &file_id,
  *                            Config &config)
  * \brief Creates the nexus file and makes and opens 
  *        the groups.
  * \param file_id The variable to store the nexus file
  *        handle in.
  * \param config Contains the format of the file and the
  *        name of the file.
  */
void layout_nexus_file(NXhandle &file_id,
                      Config &config) 
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
 
  (void)NXopen(config.out_path.c_str(), file_access, &file_id);
  (void)NXmakegroup(file_id, "entry", "NXentry");
  (void)NXopengroup(file_id, "entry", "NXentry");
  (void)NXmakegroup(file_id, "bank1", "NXevent_data");
  (void)NXopengroup(file_id, "bank1", "NXevent_data");
}

/** \fn populate_nexus_file(NXhandle &file_id,
  *                         int *const rand_tof_arr,
  *                         int *const rand_pix_arr,
  *                         Config &config)
  * \brief Populates the nexus file with the random information 
  *        that was already obtained.
  * \param file_id The handle to the nexus file.
  * \param rand_tof_arr The random time of flight array.
  * \param rand_pixel_id_arr The random pixel id array.
  * \param config Hold the size of the random arrays.
  */
void populate_nexus_file(NXhandle &file_id,
                         int *const rand_tof_arr,
                         int *const rand_pixel_id_arr,
                         Config &config)
{
  char var[12] = "10^-7second";

  (void)NXmakedata(file_id, "time_of_flight", NX_INT32, 1, &config.num_events);
  (void)NXopendata(file_id, "time_of_flight");
  (void)NXputdata(file_id, rand_tof_arr);
  (void)NXclosedata(file_id);
  (void)NXmakedata(file_id, "pixel_number", NX_INT32, 1, &config.num_events);
  (void)NXopendata(file_id, "pixel_number");
  (void)NXputdata(file_id, rand_pixel_id_arr);
  (void)NXputattr(file_id, "units", var, 11, NX_CHAR);
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
      
      ValueArg<int32_t> num_events("", "length", 
                                   "number of events to generate (default is 1000)",
                                   false, 1000, "number of events", cmd);

      ValueArg<int32_t> max_pixel_id("", "max_id",
                                     "maximum pixel id (default is 10)",
                                     false, 10, "max pixel id", cmd);

      ValueArg<int32_t> rand_seed("", "rand_seed",
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

  // Declare the arrays for the random numbers
  int rand_tof_arr[config.num_events];
  int rand_pixel_id_arr[config.num_events];
  
  // Populate the random time of flight array
  populate_tof_arr(rand_tof_arr, config);

  // Populate the random pixel id array
  populate_pixel_id_arr(rand_pixel_id_arr, config);

  // Open nexus file and layout groups
  layout_nexus_file(file_id, config);

  // Populate the nexus file with information
  populate_nexus_file(file_id, rand_tof_arr, rand_pixel_id_arr, config);

  // Close off the nexus file and any groups or data
  NXclose(&file_id);

  return 0;
}
