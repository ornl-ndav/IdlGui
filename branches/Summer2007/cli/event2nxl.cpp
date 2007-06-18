/** Author: Wes Kendall
 *  Date: 06-13-07
 *  \file rand2nxl.cpp
 *  \brief Creates a nexus light file with random values.
 */

#include "event2nxl.hpp"

using std::string;
using std::cerr;
using std::cout;
using std::endl;
using std::vector;
using std::runtime_error;
using std::type_info;
using namespace TCLAP;

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
  else if (config.format =="hdf5")
    {
      file_access = NXACC_CREATE5;
    }
  else if (config.format == "xml")
    {
      file_access = NXACC_CREATEXML;
    }
  else
    {
      throw runtime_error("Invalid nexus format type: "+config.format);
    }
 
  // Open the file, make all the groups and close them off
  if (NXopen(config.out_path.c_str(), file_access, &file_id) != NX_OK)
    {
      throw runtime_error("Failed to open nexus file: "+config.out_path);
    }
  if (NXmakegroup(file_id, "entry", "NXentry") != NX_OK)
    {
      throw runtime_error("Failed to make group: entry");
    }
  if (NXopengroup(file_id, "entry", "NXentry") != NX_OK)
    {
      throw runtime_error("Failed to open group: entry");
    }
  if (NXmakegroup(file_id, "bank1", "NXevent_data") != NX_OK)
    {
      throw runtime_error("Failed to make group: bank1");
    }
  if (NXopengroup(file_id, "bank1", "NXevent_data") != NX_OK)
    {
      throw runtime_error("Failed to open group: bank1");
    }
  if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group: bank1");
    }
  if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group: entry");
    }
}

/** \fn inline int typename_to_nexus_type(const int32_t &val)
 *  \brief Returns an int32 nexus type.
 *  \param val The type of the templated calling function
 *
 *  A templated function needs to know what type to use
 *  for the nexus api, and this function is called with a int32_t
 *  type template.
 */
inline int typename_to_nexus_type(const int32_t &val)
{
  return NX_INT32;
}

/** \fn inline int typename_to_nexus_type(const uint32_t &val)
 *  \brief Returns an uint32 nexus type.
 *  \param val The type of the templated calling function
 *
 *  A templated function needs to know what type to use
 *  for the nexus api, and this function is called with a uint32_t
 *  type template.
 */
inline int typename_to_nexus_type(const uint32_t &val)
{
  return NX_UINT32;
} 

/** \fn template <typename NumT>
  *     void write_data(const NXhandle &file_id,
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
  // Make a non constant variable to pass to nx function
  // to make sure the original is never changed
  vector<NumT> nx_data(data);
  // Get the size of the data for referencing it
  int size = data.size();
  // Get the nexus data type of the template
  NumT type;
  int nexus_data_type = typename_to_nexus_type(type);

  // Open the group 
  if (NXopenpath(file_id, group_path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open group: "+group_path);
    }
  // Make the data, open it, and write it
  if (NXmakedata(file_id, data_name.c_str(), 
                 nexus_data_type, 1, &size) != NX_OK)
    {
      throw runtime_error("Failed make data: "+data_name);
    }
  if (NXopendata(file_id, data_name.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open data: "+data_name);
    }
  if (NXputdata(file_id, &nx_data[0]) != NX_OK)
    {
      throw runtime_error("Failed to create data under "+data_name);
    }
  // Close the data and the group
  if (NXclosedata(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close data: "+data_name);
    }
  if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group: "+group_path);
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
  // Make a non const variable for NXputattr
  string nx_attr_value(attr_value);

  // Open the data
  if (NXopenpath(file_id, data_path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open data: "+data_path);
    }
  // Write the attribute for the data
  if (NXputattr(file_id, attr_name.c_str(), 
                &nx_attr_value[0], attr_value.length(),
                NX_CHAR) != NX_OK)
    {
      throw runtime_error("Failed to create attribute: "+attr_name);
    }
  // Close the data and the group
  if (NXclosedata(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close data: "+data_path);
    }
  if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group: "+data_path);
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
  EventData <uint32_t>event_data;

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
                       "event file to read from",
                       true, "", "event file", cmd);

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
      config.event_file = event_file.getValue();
      config.format = format.getValue();
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  // Gather the information from the event file
  event_data.read_data(config);
  // Open nexus file and layout groups
  layout_nexus_file(file_id, config);

  // Populate the nexus file with information
  write_data(file_id, event_data.get_tof(), "/entry/bank1", "time_of_flight");
  write_data(file_id, event_data.get_pixel_id(), "/entry/bank1", "pixel_number");
  write_attr(file_id, "units", "10^-7second", "/entry/bank1/pixel_number");

  // Close the nexus file
  if (NXclose(&file_id) != NX_OK)
    {
      throw runtime_error("Failed to close nexus file: "+config.out_path);
    }

  return 0;
}
