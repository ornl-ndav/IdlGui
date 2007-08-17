/**
 * \file event_data.cpp
 * \brief The implementation for the EventData
 *        class. For any documentation of the
 *        functions, look at event_data.hpp.
 */

#include "event_data.hpp"
#include "event2nxl.hpp"
#include <fstream>
#include <stdexcept>
#include <vector>
#include <iostream>
#include <sstream>
#include <ctime>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include <locale>

using std::stringstream;
using std::cout;
using std::endl;
using std::vector;
using std::string;
using std::runtime_error;
using std::ifstream;

// Declaring these functions prevent from having to include 
// event_data.cpp in event_data.hpp
template 
void EventData<uint32_t, uint32_t>::
read_data(const string & event_file,
          const string & pulse_id_file,
          const string & bank_file);

template 
void EventData<uint32_t, uint32_t>::
write_nexus_file(NexusUtil & nexus_util);

template 
void EventData<uint32_t, uint32_t>::
read_data(const string & event_file,
          const string & bank_file);

template 
void EventData<uint32_t, uint32_t>::
create_pixel_map(const string & mapping_file);

template 
EventData<uint32_t, uint32_t>::
EventData();

template 
EventData<uint32_t, uint32_t>::
~EventData();

template 
void EventData<uint32_t, uint64_t>::
read_data(const string & event_file,
          const string & pulse_id_file,
          const string & bank_file);

template 
void EventData<uint32_t, uint64_t>::
write_nexus_file(NexusUtil & nexus_util);

template 
void EventData<uint32_t, uint64_t>::
read_data(const string & event_file,
          const string & bank_file);

template 
void EventData<uint32_t, uint64_t>::
create_pixel_map(const string & mapping_file);

template 
EventData<uint32_t, uint64_t>::
EventData();

template 
EventData<uint32_t, uint64_t>::
~EventData();

template<typename EventNumT, typename PulseNumT>
EventData<EventNumT, PulseNumT>::
EventData()
{
}

template<typename EventNumT, typename PulseNumT>
EventData<EventNumT, PulseNumT>::
~EventData()
{
}

template<>
inline e_nx_data_type typename_to_nexus_type<uint64_t>()
{
#ifdef NX_UINT64
  return UINT64;
#else
  throw runtime_error("No nexus support for uint64");
#endif
}

template<>
inline e_nx_data_type typename_to_nexus_type<int64_t>()
{
#ifdef NX_INT64
  return INT64;
#else
  throw runtime_error("No nexus support for int64");
#endif
}

template<>
inline e_nx_data_type typename_to_nexus_type<uint32_t>()
{
  return UINT32;
}

template<>
inline e_nx_data_type typename_to_nexus_type<int32_t>()
{
  return INT32;
}

template<typename EventNumT, typename PulseNumT>
inline e_nx_data_type typename_to_nexus_type()
{
  throw runtime_error("Invalid nexus data type");
}

string get_nx_data_name(const e_data_name nx_data_type)
{
  if (nx_data_type == TOF)
    {
      return "time_of_flight";
    }
  else if (nx_data_type == PIXEL_ID)
    {
      return "pixel_number";
    }
  else if (nx_data_type == PULSE_TIME)
    {
      return "pulse_time";
    }
  else if (nx_data_type == EVENTS_PER_PULSE)
    {
      return "events_per_pulse";
    }
  else 
    {
      throw runtime_error("Invalid enumerated data type");
    }
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::
write_attr(NexusUtil & nexus_util, 
           const string & attr_name,
           const string & attr_value,
           const e_data_name nx_data_name,
           const int bank_number)
{
  string data_name;
  
  // Fill in the values that are associated with the
  // given e_data_name
  data_name = get_nx_data_name(nx_data_name);  

  open_bank(nexus_util, bank_number);
  nexus_util.open_data(data_name);
  nexus_util.put_attr(attr_name, attr_value);
}

template <typename EventNumT, typename PulseNumT>
const string & EventData<EventNumT, PulseNumT>::
get_pulse_time_offset(void)
{
  if (this->pulse_time_offset.empty())
    {
      throw runtime_error("Pulse time offset hasn't been created");
    }
  else
    {
      return this->pulse_time_offset;
    }
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::
write_nexus_file(NexusUtil & nexus_util)
{
  // First layout the nexus file
  nexus_util.make_group("entry", "NXentry");
  nexus_util.open_group("entry", "NXentry");
  
  int size = this->bank_data.bank_numbers.size();
  for (int i = 0; i < size; i++)
    { 
      stringstream bank_num;
      bank_num << "bank" << this->bank_data.bank_numbers[i];
      nexus_util.make_group(bank_num.str(), "NXevent_data");
      nexus_util.open_group(bank_num.str(), "NXevent_data");
      nexus_util.close_group();
    }
  nexus_util.close_group();
  
  // Write out each bank's information
  for (int i = 0; i < size; i++)
    {
      this->write_bank(nexus_util, this->bank_data.bank_numbers[i]);
    }
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::
write_bank(NexusUtil & nexus_util, 
           const int bank_number)
{
  Bank<EventNumT, PulseNumT> * bank = 
    this->bank_data.get_bank_by_bank_number(bank_number);
  
  if (bank->tof.size() > 0)
    {
      this->write_data(nexus_util, TOF, bank_number);
      this->write_data(nexus_util, PIXEL_ID, bank_number);
      this->write_attr(nexus_util, "units", "10^-7second", 
                       TOF, bank_number);
      if (!bank->pulse_time.empty())
        {
          this->write_data(nexus_util, PULSE_TIME, bank_number);
          this->write_data(nexus_util, EVENTS_PER_PULSE, bank_number);
          this->write_attr(nexus_util, "units", "10^-9second", 
                           PULSE_TIME, bank_number);
          this->write_attr(nexus_util, "offset", 
                           this->get_pulse_time_offset(), 
                           PULSE_TIME, bank_number);
        }
    }
}

void open_bank(NexusUtil & nexus_util,
               const int bank_number)
{
  stringstream bank_num;
  bank_num << "/entry/bank" << bank_number;
  nexus_util.open_path(bank_num.str());
}

template <typename EventNumT, typename PulseNumT>
template <typename DataNumT>
void EventData<EventNumT, PulseNumT>::
write_private_data(NexusUtil & nexus_util,
                   vector<DataNumT> & nx_data, 
                   const string & data_name,
                   const int bank_number)
{
  int dimensions = nx_data.size();
  
  // Get the nexus data type of the template
  e_nx_data_type nexus_data_type = typename_to_nexus_type<DataNumT>();
  open_bank(nexus_util, bank_number);
  nexus_util.make_data(data_name, nexus_data_type, 1, &dimensions);
  nexus_util.open_data(data_name);
  nexus_util.put_data_with_slabs(nx_data, EventNexus::DATA_SLAB_SIZE);
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::
write_data(NexusUtil & nexus_util, 
           const e_data_name nx_data_name,
           const int bank_number)
{
  string data_name;
  Bank<EventNumT, PulseNumT> * bank = 
    this->bank_data.get_bank_by_bank_number(bank_number);

  // Fill in the values that are associated with the 
  // given e_data_name
  data_name = get_nx_data_name(nx_data_name);
  if (nx_data_name == TOF)
    {
      this->write_private_data(nexus_util, 
                               bank->tof, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == PIXEL_ID)
    {
      this->write_private_data(nexus_util, 
                               bank->pixel_id, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == PULSE_TIME)
    {
      this->write_private_data(nexus_util, 
                               bank->pulse_time, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == EVENTS_PER_PULSE)
    {
      this->write_private_data(nexus_util, 
                               bank->events_per_pulse, 
                               data_name,
                               bank_number);
    }
  else
    {
      throw runtime_error("Invalid enumerated data type");
    }
}

template<typename DataT> 
void open_file_and_get_sizes(ifstream & fp,
                             const string & file_name,
                             size_t & file_size, 
                             size_t & buffer_size)
{
  if (file_name.empty())
    {
      throw runtime_error("Empty file name");
    }

  fp.open(file_name.c_str(), std::ios::binary);
  if(!(fp.is_open()))
    {
      throw runtime_error("Failed opening file: " + file_name);
    }

  fp.seekg(0, std::ios::end);
  file_size = fp.tellg() / sizeof(DataT);

  buffer_size = (file_size < BLOCK_SIZE) ?
                  file_size : BLOCK_SIZE;
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::
create_pixel_map(const string & mapping_file)
{
  size_t file_size;
  size_t buffer_size;
  ifstream file;
  open_file_and_get_sizes<uint32_t>(file,
                                    mapping_file,
                                    file_size,
                                    buffer_size);
  
  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  int32_t buffer[BLOCK_SIZE];
  size_t offset = 0;
  while(offset < file_size)
    {
      file.read(reinterpret_cast<char *>(buffer), 
                buffer_size * sizeof(uint32_t));

      // For each mapping index, map the pixel id
      // in the mapping file to that index
      for(size_t i = 0; i < buffer_size; i++)
        {
          this->pixel_id_map.push_back(*(buffer + i));
        }

      offset += buffer_size;

      // Make sure to not read past EOF
      if(offset + BLOCK_SIZE > file_size)
        {
          buffer_size = file_size - offset;
        }
    }

  // Close mapping file
  file.close();
}

template <typename NumT>
string seconds_to_iso8601(const NumT seconds)
{
  char date[100];
  // Since the times start at a different epoch (jan 1, 1990) than
  // the unix epoch (jan 1, 1970), add the number of seconds
  // between the epochs to use the ctime library
  time_t pulse_seconds = EventNexus::EPOCH_DIFF + seconds;
  struct tm *pulse_time = localtime(&pulse_seconds);
  strftime(date, sizeof(date), "%Y-%m-%dT%X-", pulse_time);
  string time(date);
  if (pulse_time->tm_isdst == 1)
    {
      time += EventNexus::EST_WITH_DST;
    }
  else
    {
      time += EventNexus::EST_WITHOUT_DST;
    }
  return time;  
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::
read_data(const string & event_file, 
          const string & bank_file)
{
  // Open the event file and get the file and buffer sizes
  size_t event_file_size;
  size_t event_buffer_size;
  ifstream event_fp; 
  open_file_and_get_sizes<EventLayout >(event_fp,
                                 event_file,
                                 event_file_size,
                                 event_buffer_size);

  // Parse the bank file and fill in the banking map
  this->bank_data.parse_bank_file(bank_file);

  // Go to the start of file and begin reading
  event_fp.seekg(0, std::ios::beg);
  EventLayout event_buffer[BLOCK_SIZE];
  size_t event_fp_offset = 0;
  while(event_fp_offset < event_file_size)
    {
      event_fp.read(reinterpret_cast<char *>(event_buffer), 
                    event_buffer_size * sizeof(EventLayout));

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for(size_t event_i = 0; event_i < event_buffer_size; event_i++)
        {
          EventLayout event = *(event_buffer + event_i);
          // Filter out error codes
          if ((static_cast<EventNumT>(event.pixel_id) & EventNexus::ERROR) 
              != EventNexus::ERROR)
            {
              // Use pointer arithmetic for speed
              Bank<EventNumT, PulseNumT> *bank = 
                this->bank_data.get_bank_by_pixel_id(
                static_cast<EventNumT>(event.pixel_id));
             
              // Put the pixel ids and time of flights in their proper bank 
              bank->tof.push_back(static_cast<EventNumT>(event.tof));
              bank->pixel_id.push_back(
                this->pixel_id_map[static_cast<EventNumT>(event.pixel_id)]);
            }
        }

      event_fp_offset += event_buffer_size;

      // Make sure to not read past EOF
      if(event_fp_offset + BLOCK_SIZE > event_file_size)
        {
          event_buffer_size = event_file_size - event_fp_offset;
        }
    }
  // Close event file
  event_fp.close();
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::
read_data(const string & event_file, 
          const string & pulse_id_file,
          const string & bank_file)
{
  EventLayout event_buffer[BLOCK_SIZE];
  PulseLayout pulse_buffer[BLOCK_SIZE];

  // Open the event file and determine file size and buffer size
  size_t event_file_size;
  size_t event_buffer_size;
  ifstream event_fp;
  open_file_and_get_sizes<EventLayout>(event_fp,
                                 event_file,
                                 event_file_size,
                                 event_buffer_size);

  // Open the pulse id file and determine file size and buffer size
  size_t pulse_file_size;
  size_t pulse_buffer_size; 
  ifstream pulse_fp; 
  open_file_and_get_sizes<PulseLayout>(pulse_fp,
                                 pulse_id_file,
                                 pulse_file_size,
                                 pulse_buffer_size);

  if (pulse_file_size == 0)
    {
      throw runtime_error("Pulse id file has no information in it");
    }

  // Get the first block from the pulse id file and read in the initial 
  // values
  pulse_fp.seekg(0, std::ios::beg);
  pulse_fp.read(reinterpret_cast<char *>(pulse_buffer), 
                pulse_buffer_size * sizeof(PulseLayout));

  // Get the first time from the pulse id and use this as the offset
  size_t pulse_buf_i = 0;
  PulseLayout pulse = *(pulse_buffer + pulse_buf_i);
  PulseNumT init_seconds = static_cast<PulseNumT>(pulse.seconds);
  this->pulse_time_offset = seconds_to_iso8601(init_seconds);

  // Get the initial time offset of the event
  PulseNumT event_time_offset = 
    static_cast<PulseNumT>(pulse.nanoseconds);  

  pulse_buf_i++;
  pulse = *(pulse_buffer + pulse_buf_i);

  // Since the first pulse offset is zero and doesn't matter, skip to the 
  // next one and start with it.
  PulseNumT pulse_index = static_cast<PulseNumT>(pulse.index);

  // Parse configuration file and read in the bank map
  this->bank_data.parse_bank_file(bank_file);

  size_t pulse_fp_offset = 0;
  size_t event_fp_offset = 0;
  PulseNumT event_number = 0;
  event_fp.seekg(0, std::ios::beg);
  while(event_fp_offset < event_file_size)
    {
      event_fp.read(reinterpret_cast<char *>(event_buffer),
                    event_buffer_size * sizeof(EventLayout));

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for(size_t event_buf_i = 0; 
          event_buf_i < event_buffer_size; 
          event_buf_i++)
        {
          // If the event_number is the same as the pulse index, 
          // then read from the pulse id buffer to get a new event 
          // time and pulse index
          if (event_number == pulse_index)
            {
              event_time_offset = static_cast<PulseNumT> 
                (((pulse.seconds * EventNexus::NANOSECS_PER_SEC) 
                   + pulse.nanoseconds)
                 - (init_seconds * EventNexus::NANOSECS_PER_SEC));

              pulse_buf_i++;
              if (pulse_buf_i == pulse_buffer_size)
                {
                  pulse_buf_i = 0;
                  pulse_fp_offset += pulse_buffer_size;
                  if(pulse_fp_offset + BLOCK_SIZE > pulse_file_size)
                    {
                      pulse_buffer_size = pulse_file_size - pulse_fp_offset;
                    }
                  pulse_fp.read(reinterpret_cast<char *>(pulse_buffer),
                                pulse_buffer_size * sizeof(PulseLayout));
                }
              pulse = *(pulse_buffer + pulse_buf_i);
              pulse_index = static_cast<PulseNumT>(pulse.index);
            }

          EventLayout event = *(event_buffer + event_buf_i);
          // Filter out error codes
          if ((event.pixel_id & EventNexus::ERROR) != EventNexus::ERROR)
            {
              // Get the proper bank from the bank map based on the pixel id
              Bank<EventNumT, PulseNumT> *bank = 
                this->bank_data.get_bank_by_pixel_id(
                static_cast<EventNumT>(event.pixel_id));
             
              // Place the pixel id and time of flight in the appropriate bank
              bank->tof.push_back(static_cast<EventNumT>(event.tof));
              bank->pixel_id.push_back(
                this->pixel_id_map[static_cast<EventNumT>(event.pixel_id)]);
             
              // If the bank has no pulse index or if a new event time
              // has been encountered, start with 1 as the events per 
              // pulse, and push back a new event time
              if (bank->pulse_index == -1 ||
                  event_time_offset !=
                  bank->pulse_time[bank->pulse_index])
                {
                  bank->pulse_index++;
                  bank->events_per_pulse.push_back(1);
                  bank->pulse_time.push_back(event_time_offset);

                }
              // If the event is still in the same pulse time, then simply 
              // increment the event number for that pulse time
              else
                {
                  bank->events_per_pulse[bank->pulse_index]++;
                }
            }
          event_number++;
        }

      event_fp_offset += event_buffer_size;

      if(event_fp_offset + BLOCK_SIZE > event_file_size)
        {
          event_buffer_size = event_file_size - event_fp_offset;
        }
    }
  // Close event file
  event_fp.close();
}
