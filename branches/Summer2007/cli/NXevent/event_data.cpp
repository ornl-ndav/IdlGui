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
void EventData<uint32_t>::read_data(const string & event_file,
                                    const string & pulse_id_file,
                                    const string & bank_file);

template 
void EventData<uint32_t>::write_data(NexusUtil & nexus_util, 
                                     const e_data_name nx_data_name,
                                     const int bank_number);

template 
void EventData<uint32_t>::write_attr(NexusUtil & nexus_util,
                                     const string & attr_name,
                                     const string & attr_value,
                                     const e_data_name nx_data_name,
                                     const int bank_number);

template 
void EventData<uint32_t>::create_pixel_map(const string & mapping_file);

template 
EventData<uint32_t>::EventData();

template 
EventData<uint32_t>::~EventData();

template<typename NumT>
EventData<NumT>::EventData()
{
}

template<typename NumT>
EventData<NumT>::~EventData()
{
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

template<typename NumT>
inline e_nx_data_type typename_to_nexus_type()
{
  throw runtime_error("Invalid nexus data type");
}

template <typename NumT>
string EventData<NumT>::get_nx_data_name(const e_data_name nx_data_type)
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

template <typename NumT>
void EventData<NumT>::open_bank(NexusUtil & nexus_util,
                                const int bank_number)
{
  nexus_util.open_path("entry/bank" + bank_number);
}

template <typename NumT>
void EventData<NumT>::write_attr(NexusUtil & nexus_util, 
                                 const string & attr_name,
                                 const string & attr_value,
                                 const e_data_name nx_data_name,
                                 const int bank_number)
{
  string data_name;
  
  // Fill in the values that are associated with the
  // given e_data_name
  data_name = this->get_nx_data_name(nx_data_name);  

  this->open_bank(nexus_util, bank_number);
  nexus_util.open_data(data_name);
  nexus_util.put_attr(attr_name, attr_value);
}

template <typename NumT>
void EventData<NumT>::parse_bank_file(const string & bank_file)
{
  // This function will parse the bank file and fill a map of the
  // number for each bank. It will also fill a vector of the bank 
  // numbers for laying out the nexus file. For now, the numbers are
  // just hardcoded. 
  this->bank_numbers.push_back(1);
  this->bank_numbers.push_back(2);
  this->bank_numbers.push_back(3);

  for (int i = 0; i < 4096; i++)
    {
      this->bank_map.push_back(1);
    }
  for (int i = 4096; i < 8192; i++)
    {
      this->bank_map.push_back(2);
    }
  for (int i = 8192; i < 9216; i++)
    {
      this->bank_map.push_back(3);
    }

  int size = this->bank_numbers.size();
  for (int i = 0; i < size; i++)
    { 
      if (this->bank_numbers[i] >= this->banks.size())
        {
          this->banks.resize(this->bank_numbers[i]);
        }
      this->banks[this->bank_numbers[i]] = new Bank<NumT>();
    }
}

template <typename NumT>
template <typename DataNumT>
void EventData<NumT>::write_private_data(NexusUtil & nexus_util,
                                         vector<DataNumT> & nx_data, 
                                         string & data_name,
                                         const int bank_number)
{
  int dimensions = nx_data.size();
  
  // Get the nexus data type of the template
  e_nx_data_type nexus_data_type = typename_to_nexus_type<NumT>();

  this->open_bank(nexus_util, bank_number);
  nexus_util.make_data(data_name, nexus_data_type, 1, &dimensions);
  nexus_util.open_data(data_name);
  nexus_util.put_data_with_slabs(nx_data, 16777215);
}

template <typename NumT>
void EventData<NumT>::write_data(NexusUtil & nexus_util, 
                                 const e_data_name nx_data_name,
                                 const int bank_number)
{
  string data_name;
  
  // Fill in the values that are associated with the 
  // given e_data_name
  data_name = this->get_nx_data_name(nx_data_name);
  if (nx_data_name == TOF)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->tof, data_name,
                               bank_number);
    }
  else if (nx_data_name == PIXEL_ID)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->pixel_id, data_name,
                               bank_number);
    }
  else if (nx_data_name == PULSE_TIME)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->pulse_time, data_name,
                               bank_number);
    }
  else if (nx_data_name == EVENTS_PER_PULSE)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->events_per_pulse, data_name,
                               bank_number);
    }
  else
    {
      throw runtime_error("Invalid enumerated data type");
    }
}
 
template <typename NumT>
void EventData<NumT>::create_pixel_map(const string & mapping_file)
{
  size_t data_size = sizeof(uint32_t);
  uint32_t mapping_index = 0;
  int32_t buffer[BLOCK_SIZE];
  size_t offset = 0;

  // Make sure the file name isn't empty
  if (mapping_file.empty())
    {
      throw runtime_error("Empty mapping file name");
    }

  // Open the mapping file
  ifstream file(mapping_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: " + mapping_file);
    }

  // Determine the file and buffer size
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg() / data_size;
  size_t buffer_size = (file_size < BLOCK_SIZE) ? file_size : BLOCK_SIZE;

  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  while(offset < file_size)
    {
      file.read(reinterpret_cast<char *>(buffer), buffer_size * data_size);

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
string EventData<NumT>::seconds_to_iso8601(NumT seconds)
{
  char date[100];
  // Since the times start at a different epoch (jan 1, 1990) than
  // the unix epoch (jan 1, 1970), add the number of seconds
  // between the epochs to use the ctime library
  const uint32_t epoch_diff = 631152000;
  time_t pulse_seconds = epoch_diff + seconds;
  struct tm *pulse_time = localtime(&pulse_seconds);
  strftime(date, sizeof(date), "%Y-%m-%dT%X-04:00", pulse_time);
  string time(date);
  return time;  
}

template <typename NumT>
void EventData<NumT>::read_data(const string & event_file, 
                                const string & bank_file)
{
  size_t event_i;
  NumT event_buffer[BLOCK_SIZE];
  size_t event_fp_offset = 0;
  size_t data_size = sizeof(NumT);
  uint32_t event_number = 0;

  // Open the event file
  ifstream event_fp(event_file.c_str(), std::ios::binary);
  if(!(event_fp.is_open()))
    {
      throw runtime_error("Failed opening file: " + event_file);
    }

  // Determine the event file and buffer size
  event_fp.seekg(0, std::ios::end);
  size_t event_file_size = event_fp.tellg() / data_size;
  size_t event_buffer_size = (event_file_size < BLOCK_SIZE) ? event_file_size : BLOCK_SIZE;

  Bank<NumT> *bank;

  this->parse_bank_file(bank_file);

  // Go to the start of file and begin reading
  event_fp.seekg(0, std::ios::beg);
  while(event_fp_offset < event_file_size)
    {
      event_fp.read(reinterpret_cast<char *>(event_buffer), event_buffer_size * data_size);

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for(event_i = 0; event_i < event_buffer_size; event_i+=2)
        {
          // Filter out error codes
          if ((*(event_buffer + event_i + 1) & ERROR) != ERROR)
            {
              // Use pointer arithmetic for speed
              bank = banks[this->bank_map[*(event_buffer + event_i + 1)]];
              
              bank->tof.push_back(*(event_buffer + event_i));
              bank->pixel_id.push_back(this->pixel_id_map[*(event_buffer + event_i + 1)]);
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

template <typename NumT>
void EventData<NumT>::read_data(const string & event_file, 
                                const string & pulse_id_file,
                                const string & bank_file)
{
  size_t event_i, pulse_i;
  NumT event_buffer[BLOCK_SIZE];
  size_t event_fp_offset = 0;
  size_t data_size = sizeof(NumT);
  uint32_t event_number = 0;

  // Open the event file
  ifstream event_fp(event_file.c_str(), std::ios::binary);
  if(!(event_fp.is_open()))
    {
      throw runtime_error("Failed opening file: " + event_file);
    }

  // Determine the event file and buffer size
  event_fp.seekg(0, std::ios::end);
  size_t event_file_size = event_fp.tellg() / data_size;
  size_t event_buffer_size = (event_file_size < BLOCK_SIZE) ? event_file_size : BLOCK_SIZE;

  NumT pulse_buffer[BLOCK_SIZE];
  size_t pulse_fp_offset = 0;
  NumT init_seconds = 0;
  NumT prev_index = 0;
  NumT prev_time;
  NumT pulse_index;

  // Open the pulse id file
  ifstream pulse_fp(pulse_id_file.c_str(), std::ios::binary);
  if(!(pulse_fp.is_open()))
    {
      throw runtime_error("Failed opening file: " + pulse_id_file);
    }

  // Determine the file and buffer size
  pulse_fp.seekg(0, std::ios::end);
  size_t pulse_file_size = pulse_fp.tellg() / data_size;
  size_t pulse_buffer_size = (pulse_file_size < BLOCK_SIZE) ? pulse_file_size : BLOCK_SIZE;

  // Read in the initial time and convert it to ISO8601. Skip the initial
  // index since it will always be zero.
  pulse_fp.seekg(0, std::ios::beg);
  pulse_fp.read(reinterpret_cast<char *>(pulse_buffer), pulse_buffer_size * data_size);
  this->pulse_time_offset =
    this->seconds_to_iso8601(static_cast<NumT>(*(pulse_buffer + 1)));
  init_seconds = static_cast<NumT>(*(pulse_buffer + 1));

  // Get the initial time offset
  prev_time = static_cast<NumT>(*(pulse_buffer));  

  // Since the first pulse offset is zero and doesn't matter, skip to the next one and
  // start with it.
  pulse_i = 4; 
  pulse_index = static_cast<NumT>(*(pulse_buffer + pulse_i + 2));
  // Make sure to not read past EOF
  if(pulse_fp_offset + BLOCK_SIZE > pulse_file_size)
    {
      pulse_buffer_size = pulse_file_size - pulse_fp_offset;
    }

  Bank<NumT> *bank;
  this->parse_bank_file(bank_file);

  // Go to the start of file and begin reading
  event_fp.seekg(0, std::ios::beg);
  while(event_fp_offset < event_file_size)
    {
      event_fp.read(reinterpret_cast<char *>(event_buffer), event_buffer_size * data_size);

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for(event_i = 0; event_i < event_buffer_size; event_i+=2)
        {
          if (event_number == pulse_index)
            {
              prev_time = ((static_cast<NumT>(*(pulse_buffer + pulse_i + 1)) * 1000000000)
                          + static_cast<NumT>(*(pulse_buffer + pulse_i)))
                          -((init_seconds * 1000000000));
              pulse_i += 4;
              if (pulse_i == pulse_buffer_size)
                {
                  pulse_i = 0;
                  pulse_fp_offset += pulse_buffer_size;
                  if(pulse_fp_offset + BLOCK_SIZE > pulse_file_size)
                    {
                      pulse_buffer_size = pulse_file_size - pulse_fp_offset;
                    }
                  pulse_fp.read(reinterpret_cast<char *>(pulse_buffer), pulse_buffer_size * data_size);
                }
              pulse_index = static_cast<NumT>(*(pulse_buffer + pulse_i + 2));
            }
          // Filter out error codes
          if ((*(event_buffer + event_i + 1) & ERROR) != ERROR)
            {
              // Use pointer arithmetic for speed
              bank = this->banks[this->bank_map[*(event_buffer + event_i + 1)]];
              
              bank->tof.push_back(*(event_buffer + event_i));
              bank->pixel_id.push_back(this->pixel_id_map[*(event_buffer + event_i + 1)]);
              if (bank->pulse_index == -1 ||
                  prev_time !=
                  bank->pulse_time[bank->pulse_index])
                {
                  bank->pulse_index++;
                  bank->events_per_pulse.push_back(1);
                  bank->pulse_time.push_back(prev_time);
                }
              else
                {
                  bank->events_per_pulse[bank->pulse_index]++;
                }
            }
          event_number++;
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
