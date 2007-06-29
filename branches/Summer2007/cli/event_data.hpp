/** Author: Wes Kendall
 *  Date: 06-26-07
 *  \file event_data.hpp
 *  \brief The function declarations, includes, and class
 *         definition for event_data.cpp.
 */

#ifndef _EVENT_DATA_HPP
#define _EVENT_DATA_HPP 1

#include "nexus_util.hpp"
#include <vector>
#include <string>

const uint32_t ERROR=0x80000000;

/** \enum e_data_name
 *  \brief Enumeration of the data in the nexus file.
 *  
 *  e_data_name is used primarily for the compiler
 *  to catch any erronous values given to functions.
 */
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
    /** \fn void read_event_file(const string &event_file)
     *  \brief Reads information from the event file and populates
     *         the tof and pixel id vectors.
     *  \param event_file The event file to read from.
     */
    void read_event_file(const std::string &event_file);

    /** \fn void read_pulse_id_file(const string &pulse_id_file)
     *  \brief Reads information from the pulse id file.
     *  \param pulse_id_file The pulse id file to read from.
     */
    void read_pulse_id_file(const std::string &pulse_id_file);

    void seconds_to_iso8601(NumT seconds, std::string &time);

    /** \fn void map_pixel_ids(const std::string &mapping_file)
     *  \brief Takes a mapping file and maps the pixels to
     *         the appropriate numbers.
     *  \param mapping_file The mapping file to use.
     */
    void map_pixel_ids(const std::string &mapping_file);

     /** \fn void write_data(NexusUtil &nexus_util,
      *                     const e_data_name nx_data_name)
      * \brief Templated function that writes data to a nexus
      *        file.
      * \param nexus_util The nexus utility.
      * \param nx_data_name The enumeration specifying which 
      *                     piece of data to write.
      */
    void write_data(NexusUtil &nexus_util,
                    const e_data_name nx_data_name);

    /** \fn void write_attr(NexusUtil &nexus_util,
      *                     const string &attr_name,
      *                     const string &attr_value,
      *                     const e_data_name nx_data_name)
      * \brief Opens a data field in a nexus file and
      *        writes an attribute for it.
      * \param nexus_util The nexus utility.
      * \param attr_name The name of the attribute.
      * \param group_value The value associated with
      *                    the attribute.
      * \param nx_data_name The enumeration specifying which
      *                     piece of data to write.
      */
    void write_attr(NexusUtil &nexus_util,
                    const std::string &attr_name,
                    const std::string &attr_value,
                    const e_data_name nx_data_name);
  
    /** \fn inline int typename_to_nexus_type(const int32_t &val)
     *  \brief Returns an int32 nexus type.
     *  \param val The type of the templated calling function
     */
    inline int typename_to_nexus_type(const int32_t &val);

    /** \fn inline int typename_to_nexus_type(const uint32_t &val)
     *  \brief Returns an uint32 nexus type.
     *  \param val The type of the templated calling function
     */
    inline int typename_to_nexus_type(const uint32_t &val);

    /** \fn void get_nx_data_values(const e_data_name nx_data_type,
     *                              string &data_name)
     *  \brief Fills in the nexus values associated with the
     *         e_data_name enumeration.
     *  \param nx_data_type The enumeration specifying which piece
     *                      of data. Ex - TOF for time of flight.
     *  \param data_name The string to fill in the actual name
     *                   associated with the enumeration. Ex -
     *                   data_name will be set to "time_of_flight"
     *                   if the nx_data_type is TOF.
     */
    void get_nx_data_values(const e_data_name nx_data_type,
                            std::string &data_name);
    
    /** \fn void get_nx_data_values(const e_data_name nx_data_type,
     *                              string &data_name, 
     *                              vector<NumT> &data)
     *  \brief Fills in the nexus values associated with the
     *         e_data_name enumeration.
     *  \param nx_data_type The enumeration specifying which piece
     *                      of data. Ex - TOF for time of flight.
     *  \param data_name The string to fill in the actual name
     *                   associated with the enumeration. Ex -
     *                   data_name will be set to "time_of_flight"
     *                   if the nx_data_type is TOF.
     *  \param data The chunk of data that will be set properly
     *              according to the enumeration.
     */
    void get_nx_data_values(const e_data_name nx_data_type,
                            std::string &data_name,
                            std::vector<NumT> &data);

    /* \fn EventData(const string &path)
     * \brief Constructor the EventData class.
     * \param path The path to the data in the nexus file.
     */
    EventData(const std::string &path);
};

#endif
