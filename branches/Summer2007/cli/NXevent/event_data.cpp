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
#include <map>
#include <vector>
#include <iostream>
#include <sstream>
#include <ctime>

using std::stringstream;
using std::cout;
using std::endl;
using std::vector;
using std::string;
using std::map;
using std::runtime_error;
using std::ifstream;

// Declaring these functions prevent from having to include 
// event_data.cpp in event_data.hpp
template 
void EventData<uint32_t>::read_data(const string & event_file,
                                    const string & pulse_id_file);

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
void EventData<uint32_t>::map_pixel_ids(const string & mapping_file);

template 
void EventData<uint32_t>::write_nexus_file(NexusUtil & nexus_util,
                                           const string & bank_file);

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
void EventData<NumT>::parse_bank_file(const string & bank_file,
                                      map<NumT, int> & bank_map,
                                      vector<int> & bank_numbers)
{
  // This function will parse the bank file and fill a map of the
  // number for each bank. It will also fill a vector of the bank 
  // numbers for laying out the nexus file. For now, the numbers are
  // just hardcoded. 
  bank_numbers.push_back(1);
  bank_numbers.push_back(2);
  bank_numbers.push_back(3);

  for (int i = 0; i < 4096; i++)
    {
      bank_map[i] = 1;
    }
  for (int i = 4096; i < 8192; i++)
    {
      bank_map[i] = 2;
    }
  for (int i = 8192; i < 9216; i++)
    {
      bank_map[i] = 3;
    }
}

template <typename NumT>
void EventData<NumT>::write_nexus_file(NexusUtil & nexus_util,
                                       const string & bank_file)
{
  map<NumT, int> bank_map;
  vector<int> bank_numbers;
  map<int, Bank *> banks;

  this->parse_bank_file(bank_file, bank_map, bank_numbers);
  int size = bank_numbers.size();
  for (int i = 0; i < size; i++)
    {
      banks[bank_numbers[i]] = new Bank;
    }

  // Split the pixel ids and tofs into banks
  size = this->pixel_id.size();
  for (int i = 0; i < size; i++)
    {
      banks[bank_map[pixel_id[i]]]->tof.push_back(this->tof[i]);
      banks[bank_map[pixel_id[i]]]->pixel_id.push_back(this->pixel_id[i]);
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
                               this->tof, data_name,
                               bank_number);
    }
  else if (nx_data_name == PIXEL_ID)
    {
      this->write_private_data(nexus_util, 
                               this->pixel_id, data_name,
                               bank_number);
    }
  else if (nx_data_name == PULSE_TIME)
    {
      this->write_private_data(nexus_util, 
                               this->pulse_time, data_name,
                               bank_number);
    }
  else if (nx_data_name == EVENTS_PER_PULSE)
    {
      this->write_private_data(nexus_util, 
                               this->events_per_pulse, data_name,
                               bank_number);
    }
  else
    {
      throw runtime_error("Invalid enumerated data type");
    }
}
 
template <typename NumT>
void EventData<NumT>::map_pixel_ids(const string & mapping_file)
{
  map<uint32_t, uint32_t> pixel_id_map;
  size_t data_size = sizeof(uint32_t);
  uint32_t mapping_index = 0;
  int32_t buffer[BLOCK_SIZE];
  size_t offset = 0;

  // Make sure the file name isn't empty
  if (mapping_file.empty())
    {
      throw runtime_error("Empty mapping file name");
    }

  // If the data hasn't been read yet, throw an exception
  if (this->pixel_id.size() == 0)
    {
      throw runtime_error("Must read data before mapping");
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
          pixel_id_map[mapping_index] = *(buffer + i);
          mapping_index++;
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

  // After creating the map, map the pixel ids to the proper value
  int size = this->pixel_id.size();
  for(size_t i = 0; i < size; i++)
    {
      this->pixel_id[i] = pixel_id_map[this->pixel_id[i]];
    }
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
                                const string & pulse_id_file)
{
  NumT buffer[BLOCK_SIZE];
  size_t offset = 0;
  size_t i;
  size_t data_size = sizeof(NumT);
  NumT init_seconds = 0;
  NumT prev_index = 0;

  // Open the pulse id file
  ifstream file(pulse_id_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: " + pulse_id_file);
    }

  // Determine the file and buffer size
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg() / data_size;
  size_t buffer_size = (file_size < BLOCK_SIZE) ? file_size : BLOCK_SIZE;

  // Read in the initial time and convert it to ISO8601. Skip the initial 
  // index since it will always be zero.
  file.seekg(0, std::ios::beg);
  file.read(reinterpret_cast<char *>(buffer), sizeof(NumT) * 4);
  this->pulse_time_offset = 
    this->seconds_to_iso8601(static_cast<NumT>(*(buffer + 1)));
  init_seconds = static_cast<NumT>(*(buffer + 1));

  // Push back the initial time offset
  pulse_time.push_back(static_cast<NumT>(*(buffer)));

  offset += 4;
  // Make sure to not read past EOF
  if(offset + BLOCK_SIZE > file_size)
    {
      buffer_size = file_size - offset;
    }

  while(offset < file_size)
    {
      file.read(reinterpret_cast<char *>(buffer), buffer_size * data_size);

      // Keep track of the time offsets and read in the pulse times
      for(i = 0; i < buffer_size; i+=4)
        {
          pulse_time.push_back(
            ((static_cast<NumT>(*(buffer + i + 1)) * 1000000000) 
             + static_cast<NumT>(*(buffer + i)))
            -((init_seconds * 1000000000))
          );
          events_per_pulse.push_back(static_cast<NumT>(*(buffer + i + 2)) 
                                     - prev_index);
          prev_index = static_cast<NumT>(*(buffer + i + 2));
          //cout << prev_index << endl;
        }

      offset += buffer_size;

      // Make sure to not read past EOF
      if(offset + BLOCK_SIZE > file_size)
        {
          buffer_size = file_size - offset;
        }
    }

  // Find out the number of events for the last pulse
  ifstream file2(event_file.c_str(), std::ios::binary);
  if(!(file2.is_open()))
    {
      throw runtime_error("Failed opening file: " + event_file);
    }

  // Determine the file and buffer size
  file2.seekg(0, std::ios::end);
  events_per_pulse.push_back(file2.tellg() / (data_size * 2) - prev_index);
  file2.close();
  
  read_data(event_file);
}

template <typename NumT>
void EventData<NumT>::read_data(const string & event_file)
{
  NumT buffer[BLOCK_SIZE];
  size_t offset = 0;
  size_t i;
  size_t data_size = sizeof(NumT);
  int event_number = 0;
  bool pulse_id_exists = (events_per_pulse.empty()) ? false : true;
  int pulse_index = 0;
  int pulse_offset = 0;
  int events_per_pulse_size;

  // Open the event file
  ifstream file(event_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: " + event_file);
    }

  // Determine the file and buffer size
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg() / data_size;
  size_t buffer_size = (file_size < BLOCK_SIZE) ? file_size : BLOCK_SIZE;

  if (pulse_id_exists)
    {
      pulse_offset = this->events_per_pulse[pulse_index];
      events_per_pulse_size = this->events_per_pulse.size();
    }

  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  while(offset < file_size)
    {
      file.read(reinterpret_cast<char *>(buffer), buffer_size * data_size);

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for(i = 0; i < buffer_size; i+=2)
        {
          if (pulse_id_exists && (event_number == pulse_offset))
            {
              pulse_index++;
              if (pulse_index < events_per_pulse_size)
                {
                  pulse_offset += this->events_per_pulse[pulse_index];
                }
            }

          // Filter out error codes
          if ((*(buffer + i + 1) & ERROR) != ERROR)
            {
              //cout << *(buffer + i + 1) << endl;
              // Use pointer arithmetic for speed
              this->tof.push_back(*(buffer + i));
              this->pixel_id.push_back(*(buffer + i + 1));
            }
          else if (pulse_id_exists)
            {
              if (pulse_index < events_per_pulse_size)
                {
                  events_per_pulse[pulse_index]--;
                }
            }
          event_number++;
        }

      offset += buffer_size;

      // Make sure to not read past EOF
      if(offset + BLOCK_SIZE > file_size)
        {
          buffer_size = file_size - offset;
        }
    }
  
  // Close event file
  file.close();
}
