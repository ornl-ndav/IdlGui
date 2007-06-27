/** Author: Wes Kendall
 *  Date: 06-26-07
 *  \file event_data.hpp
 *  \brief The function declarations, includes, and class
 *         definition for event_data.cpp.
 */

#ifndef _EVENT_DATA_HPP
#define _EVENT_DATA_HPP 1

#include <vector>
#include <string>
#include <map>
#include <fstream>
#include <stdexcept>
#include "nexus_util.hpp"

typedef enum e_data_name
{
  TOF = 0,
  PIXEL_ID = 1
};

/** \class EventData
 *  \brief Holds all the data from the event file and
 *         includes the functions for working on the
 *         data
 */
template <typename NumT>
class EventData
{
  private:
    std::vector<NumT> tof;
    std::vector<NumT> pixel_id;
    std::string data_path;
  public:
    /** \fn void read_data(const Config &config)
     *  \brief Reads information from the event file and populates
     *         the data vectors.
     *  \param config The configuration options.
     */
    void read_data(const std::string &event_file);

    /** \fn void map_pixel_ids(const std::string &mapping_file,
     *                         map<uint32_t, uint32_t> &mapped_pixel_ids)
     *  \brief Takes a mapping file and maps the pixels to
     *         the appropriate numbers.
     */
    void map_pixel_ids(const std::string &mapping_file);

    /** \fn const std::vector<NumT> get_tof(void)
     *  \brief Returns a constant vector to the private tof vector.
     */
    const std::vector<NumT> get_tof(void);

    /** \fn const std::vector<NumT> get_pixel_id(void)
     *  \brief Returns a constant vector to the private pixel_id vector.
     */
    const std::vector<NumT> get_pixel_id(void);

    void write_data(NexusUtil &nexus_util,
                    const e_data_name nx_data_name);

    void write_attr(NexusUtil &nexus_util,
                    const std::string &attr_name,
                    const std::string &attr_value,
                    const e_data_name nx_data_name);
   
    inline int typename_to_nexus_type(const int32_t &val);

    inline int typename_to_nexus_type(const uint32_t &val);

    EventData(const std::string &path);
};

#endif
