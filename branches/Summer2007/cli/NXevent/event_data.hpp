/**
 * \file event_data.hpp
 * \brief The function declarations, includes, and class
 *        definition for event_data.cpp.
 */

#ifndef _EVENT_DATA_HPP
#define _EVENT_DATA_HPP 1

#include "nexus_util.hpp"
#include "Bank.hpp"
#include <vector>
#include <string>
#include <cstdlib>
#include <locale>
#include <libxml/parser.h>
#include <libxml/tree.h>

const uint32_t ERROR = 0x80000000;
const uint32_t NANOSECS_PER_SEC = 1000000000;

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
 * \brief Takes a number of seconds since jan 1, 1990
 *        and converts it to an iso8601 date string.
 * \param seconds The number of seconds since jan 1, 1990.
 * \param nanoseconds The nanoseconds of the current second.
 * \param time The variable to store the ISO8601 date string in.
 */
std::string seconds_to_iso8601(uint32_t seconds);

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
    std::vector<NumT> pixel_id_map;
    std::string pulse_time_offset;
    std::vector<Bank<NumT> *> bank_map;
    std::vector<int> bank_numbers;
    std::vector<NumT> events_per_pulse;
    std::vector<Bank<NumT> *> banks;
   
    /**
     * \brief Opens a bank in a nexus file.
     * \param nexus_util The nexus utility
     * \param bank_number The number of the bank to open
     */
    void open_bank(NexusUtil & nexus_util, const int bank_number);

    void create_step_list(xmlNodePtr bank_node, int bank_number);

    void create_cont_list(xmlNodePtr bank_node, int bank_number);
   
    void create_arbitrary(xmlNodePtr bank_node, int bank_number);
 
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
 
    /**
     * \brief Writes the private data from EventData to a nexus file.
     * \param nexus_util The nexus utility with the open file handle.
     * \param nx_data The data to be written to the nexus file.
     * \param data_name The name of the data to be written 
     *                  (ex. time_of_flight).
     * \param bank_number The bank number of the data being written.
     */
    void write_private_data(NexusUtil & nexus_util, 
                            std::vector<NumT> & nx_data,
                            std::string & data_name,
                            const int bank_number);

  public:
    /**
     * \brief Gets the initial pulse time offset string from the
     *        EventData class.
     * \exception runtime_error Thrown if the initial pulse offset hasn't
     *                          been read in.
     */
    const std::string & get_pulse_time_offset(void);

    /**
     * \brief Parses the banking configuration file and sets up the
     *        bank data structures and maps.
     * \param bank_file The name of the xml bank configuration file.
     * \exception runtime_error Thrown if any error happens in the xml 
     *                          parsing.
     */
    void parse_bank_file(const std::string & bank_file);
 
    /**
     * \brief Reads information from the event file and populates
     *        the tof and pixel id vectors.
     * \param event_file The event file to read from.
     * \param bank_file The bank configuration file.
     * \exception runtime_error Thrown if the event file can't be opened.
     */
    void read_data(const std::string & event_file,
                   const std::string & bank_file);

    /**
     * \brief Reads information from the pulse id file and event file.
     * \param event_file The event file to read from.
     * \param pulse_id_file The pulse id file to read from.
     * \param bank_file The bank configuration file. 
     * \exception runtime_error Thrown if any of the files
     *                          can't be opened.
     */
    void read_data(const std::string & event_file,
                   const std::string & pulse_id_file,
                   const std::string & bank_file);

    /**
     * \brief Takes a mapping file and creates a pixel id map.
     * \param mapping_file The mapping file to use.
     * \exception runtime_error Thrown if the mappging file doesn't
     *                          exist or if the data hasn't been read
     *                          in yet.
     */
    void create_pixel_map(const std::string & mapping_file);

    /**
     * \brief Writes the data to a nexus file. This is the overloaded 
     *        function for when a pulse id file is present.
     * \param nexus_util The nexus utility with the open file handle.
     * \param pulse_id_file The name of the pulse id file. This parameter
     *                      isn't used. It is only for overloading the function.
     */
    void write_nexus_file(NexusUtil & nexus_util, const std::string & pulse_id_file);

    /**
     * \brief Writes the data to a nexus file. This is the overloaded
     *        function for when a pulse id file isn't present. 
     * \param nexus_util The nexus utility with the open file handle.
     */
    void write_nexus_file(NexusUtil & nexus_util);

    /**
     * \brief Templated function that writes data to a nexus
     *        file.
     * \param nexus_util The nexus utility.
     * \param nx_data_name The enumeration specifying which 
     *                     piece of data to write.
     * \param bank_number The number of the bank to write data to.
     */
    void write_data(NexusUtil & nexus_util,
                    const e_data_name nx_data_name,
                    const int bank_number);

    /**
     * \brief Opens a data field in a nexus file and
     *        writes an attribute for it.
     * \param nexus_util The nexus utility.
     * \param attr_name The name of the attribute.
     * \param group_value The value associated with
     *                    the attribute.
     * \param nx_data_name The enumeration specifying which
     *                     piece of data to write.
     * \param bank_number The bank number of the data.
     */
    void write_attr(NexusUtil & nexus_util,
                    const std::string & attr_name,
                    const std::string & attr_value,
                    const e_data_name nx_data_name,
                    const int bank_number);
  
    /**
     * \brief Constructor the EventData class.
     */
    EventData();

    /**
     * \brief The destructor for the EventData class.
     */
    ~EventData();
};

#endif
