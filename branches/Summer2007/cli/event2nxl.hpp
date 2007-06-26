/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file event2nxl.hpp
 *  \brief The function declarations, includes, and class/struct 
 *         definitions for event2nxl.cpp.
 */

#ifndef _EVENT2NXL_HPP
#define _EVENT2NXL_HPP

#include "napi.h"
#include "nexus_util.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cstdlib>
#include <fstream>
#include <stdexcept>
#include <libgen.h>
#include <typeinfo>
#include <tclap/CmdLine.h>

using std::vector;
using std::string;
using std::map;

const string VERSION("1.0");
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
  string out_path;
  string format;
  string event_file;
  string pulse_id_file;
  string mapping_file;
};

/** \class Event_Data
 *  \brief Holds all the data from the event file and
 *         includes the functions for working on the
 *         data
 */
template <typename NumT>
class EventData 
{
  private:
    vector<NumT> tof;
    vector<NumT> pixel_id;
  public:
    /** \fn void read_data(const Config &config)
     *  \brief Reads information from the event file and populates
     *         the data vectors.
     *  \param config The configuration options.
     */
    void read_data(const Config &config);

    /** \fn void map_pixel_ids(const string &mapping_file,
     *                         map<uint32_t, uint32_t> &mapped_pixel_ids)
     *  \brief Takes a mapping file and maps the pixels to
     *         the appropriate numbers.
     */
    void map_pixel_ids(const string &mapping_file,
                       map<uint32_t, uint32_t> &pixel_id_map);

    /** \fn const vector<NumT> get_tof(void)
     *  \brief Returns a constant vector to the private tof vector.
     */
    const vector<NumT> get_tof(void);

    /** \fn const vector<NumT> get_pixel_id(void)
     *  \brief Returns a constant vector to the private pixel_id vector.
     */
    const vector<NumT> get_pixel_id(void);
};

#endif
