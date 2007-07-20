/**
 * \file event_data.hpp
 * \brief The function declarations, includes, and class
 *        definition for event_data.cpp.
 */

#ifndef _EVENT_DATA_HPP
#define _EVENT_DATA_HPP 1

#include "nexus_util.hpp"
#include <vector>
#include <string>

const uint32_t ERROR=0x80000000;

/** 
 * \enum e_data_name
 * \brief Enumeration of the data in the nexus file.
 * 
 * e_data_name is used primarily for the compiler
 * to catch any erronous values given to functions.
 */
typedef enum e_data_name
{
  TOF = 0,
  PIXEL_ID = 1,
  PULSE_TIME = 2,
  EVENTS_PER_PULSE = 3
};
    
/**
 * \brief Turns a type (like uint32_t) into a valid nexus
 *        type. 
 * \return The enumerator for the nexus data type.
 * \exception runtime_error Thrown if the function isn't
 *                          instantiated for the type given.
 */
template <typename NumT>
inline e_nx_data_type typename_to_nexus_type(void);

/** 
 * \class EventData
 * \brief Holds all the data from the event file and
 *        includes the functions for working on the
 *        data
 */
template <typename NumT>
class EventData
{
  private:
    std::vector<NumT> tof;
    std::vector<NumT> pixel_id;
    std::vector<uint64_t> pulse_time;
    std::vector<uint64_t> events_per_pulse;
    std::string data_path;
    std::string pulse_time_offset;

    /** 
     * \brief Takes a number of seconds since jan 1, 1990
     *        and converts it to an iso8601 date string.
     * \param seconds The number of seconds since jan 1, 1990.
     * \param nanoseconds The nanoseconds of the current second.
     * \param time The variable to store the ISO8601 date string in.
     */
    std::string seconds_to_iso8601(NumT seconds);
    
    /**
     * \brief Fills in the nexus values associated with the
     *        e_data_name enumeration.
     * \param nx_data_type The enumeration specifying which piece
     *                     of data. Ex - TOF for time of flight.
     * \exception runtime_error Thrown if the enumeration value is 
     *                          invalid.
     * \return The string representation of the data. Ex - 
     *         "time_of_flight" for TOF.
     */
    std::string get_nx_data_name(const e_data_name nx_data_type);
    
    template <typename DataNumT>
    void write_private_data(NexusUtil & nexus_util, 
                            std::vector<DataNumT> & nx_data,
                            std::string & data_name);

  public:
    /**
     * \brief Reads information from the event file and populates
     *        the tof and pixel id vectors.
     * \param event_file The event file to read from.
     * \exception runtime_error Thrown if the event file can't be opened.
     */
    void read_data(const std::string & event_file);

    /**
     * \brief Reads information from the pulse id file and event file.
     * \param event_file The event file to read from.
     * \param pulse_id_file The pulse id file to read from.
     * \exception runtime_error Thrown if any of the files
     *                          can't be opened.
     */
    void read_data(const std::string & event_file,
                   const std::string & pulse_id_file);

    /**
     * \brief Takes a mapping file and maps the pixels to
     *        the appropriate numbers.
     * \param mapping_file The mapping file to use.
     * \exception runtime_error Thrown if the mappging file doesn't
     *                          exist or if the data hasn't been read
     *                          in yet.
     */
    void map_pixel_ids(const std::string & mapping_file);

    /**
     * \brief Templated function that writes data to a nexus
     *        file.
     * \param nexus_util The nexus utility.
     * \param nx_data_name The enumeration specifying which 
     *                     piece of data to write.
     */
    void write_data(NexusUtil & nexus_util,
                    const e_data_name nx_data_name);

    /**
     * \brief Opens a data field in a nexus file and
     *        writes an attribute for it.
     * \param nexus_util The nexus utility.
     * \param attr_name The name of the attribute.
     * \param group_value The value associated with
     *                    the attribute.
     * \param nx_data_name The enumeration specifying which
     *                     piece of data to write.
     */
    void write_attr(NexusUtil & nexus_util,
                    const std::string & attr_name,
                    const std::string & attr_value,
                    const e_data_name nx_data_name);
  
    /**
     * \brief Constructor the EventData class.
     * \param path The path to the data in the nexus file.
     */
    EventData(const std::string & data_path);

    /**
     * \brief The destructor for the EventData class.
     */
    ~EventData();
};

#endif
