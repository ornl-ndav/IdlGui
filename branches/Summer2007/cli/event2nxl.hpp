/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file event2nxl.hpp
 *  \brief The function declarations, includes, and struct 
 *         definitions for event2nxl.cpp.
 */

#ifndef _EVENT2NXL_HPP
#define _EVENT2NXL_HPP 1

#include "nexus_util.hpp"
#include <string>
#include <vector>

const std::string VERSION("1.0");
const size_t BLOCK_SIZE = 1024;

/** \struct Config
 *  \brief Holds all the configuration variables
 *
 *  The config struct holds all the information obtained
 *  by the command line parser the all the variables can
 *  easily be passed to functions.
 */
struct Config
{
  std::string out_path;
  std::string format;
  std::string event_file;
  std::string pulse_id_file;
  std::string mapping_file;
};

/** \fn void layout_nexus_file(NXhandle &file_id,
  *                            const Config &config)
  * \brief Creates the nexus file and makes and opens
  *        the groups.
  * \param file_id The variable to store the nexus file
  *        handle in.
  * \param config Contains the format of the file and the
  *        name of the file.
  */
void layout_nexus_file(NexusUtil &nexus_util,
                       const Config &config);

/** \fn inline int typename_to_nexus_type(const int32_t &val)
 *  \brief Returns an int32 nexus type.
 *  \param val The type of the templated calling function
 *
 *  A templated function needs to know what type to use
 *  for the nexus api, and this function is called with a int32_t
 *  type template.
 */
inline int typename_to_nexus_type(const int32_t &val);

/** \fn inline int typename_to_nexus_type(const uint32_t &val)
 *  \brief Returns an uint32 nexus type.
 *  \param val The type of the templated calling function
 *
 *  A templated function needs to know what type to use
 *  for the nexus api, and this function is called with a uint32_t
 *  type template.
 */
inline int typename_to_nexus_type(const uint32_t &val);

/** \fn template <typename NumT>
  *     void write_data(const NXhandle &file_id,
  *                     const std::vector<NumT> &data,
  *                     const std::string &group_path,
  *                     const std::string &data_name)
  * \brief Templated function that opens a group
  *        in a nexus file and writes data.
  * \param file_id The handle for the nexus file.
  * \param data Templated std::vector of data to be
  *             written.
  * \param group_path The group to write the data
  *                   to in the nexus file.
  * \param data_name The name of the data.
  */
template <typename NumT>
void write_data(NexusUtil &nexus_util,
                const std::vector<NumT> &data,
                const std::string &group_path,
                const std::string &data_name);

/** \fn void write_attr(const NXhandle &file_id,
  *                     const std::string &attr_name,
  *                     const std::string &attr_value,
  *                     const std::string &data_path)
  * \brief Opens a data field in a nexus file and
  *        writes an attribute for it.
  * \param file_id The handle for the nexus file.
  * \param attr_name The name of the attribute.
  * \param group_value The value associated with
  *                    the attribute
  * \param data_path The path to the data
  */
void write_attr(NexusUtil &nexus_util,
                const std::string &attr_name,
                const std::string &attr_value,
                const std::string &data_path);

#endif
