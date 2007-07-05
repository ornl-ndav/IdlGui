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

/** \fn void layout_nexus_file(NexusUtil &nexus_util,
  *                            const Config &config)
  * \brief Creates the nexus file and makes and opens
  *        the groups.
  * \param nexus_util The nexus utility.
  * \param config Contains the format of the file and the
  *        name of the file.
  */
void layout_nexus_file(NexusUtil &nexus_util,
                       const Config &config);

#endif
