/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file event_data.cpp
 *  \brief The implementation for the EventData
 *         class.
 */

#include "event_data.hpp"
#include "event2nxl.hpp"
#include <fstream>
#include <stdexcept>
#include <map>
#include <vector>
#include <iostream>

using std::vector;
using std::string;
using std::map;
using std::runtime_error;

// Declaring these functions prevent from having to include 
// event_data.cpp in event_data.hpp
template const vector<uint32_t> EventData<uint32_t>::get_tof(void);
template const vector<uint32_t> EventData<uint32_t>::get_pixel_id(void);
template void EventData<uint32_t>::read_data(const string &);
template void EventData<uint32_t>::map_pixel_ids(const string &);

template <typename NumT>
void EventData<NumT>::map_pixel_ids(const string &mapping_file)
{
  map<uint32_t, uint32_t> pixel_id_map;
  size_t data_size = sizeof(uint32_t);
  uint32_t mapping_index = 0;
  int32_t buffer[BLOCK_SIZE];
  size_t offset = 0;

  // If the data hasn't been read yet, throw an exception
  if (pixel_id.size() == 0)
    {
      throw runtime_error("Must read data before mapping");
    }

  // Open the mapping file
  std::ifstream file(mapping_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: "+mapping_file);
    }

  // Determine the file and buffer size
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg() / data_size;
  size_t buffer_size = (file_size < BLOCK_SIZE) ? file_size : BLOCK_SIZE;

  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  while(offset < file_size)
    {
      file.seekg(offset * data_size, std::ios::beg);
      file.read(reinterpret_cast<char *>(buffer), buffer_size * data_size);

      // For each mapping index, map the pixel id
      // in the mapping file to that index
      for( size_t i = 0; i < buffer_size; i++ )
        {
          pixel_id_map[mapping_index] = *(buffer + i);
          mapping_index++;
        }

      offset += buffer_size;

      // Make sure to not read past EOF
      if(offset+BLOCK_SIZE > file_size)
        {
          buffer_size = file_size-offset;
        }
    }

  // Close mapping file
  file.close();

  // After creating the map, map the pixel ids to the proper value
  int size = pixel_id.size();
  for ( size_t i = 0; i < size; i++ )
    {
      pixel_id[i] = pixel_id_map[pixel_id[i]];
    }
}

template <typename NumT>
void EventData<NumT>::read_data(const string &event_file) 
{
  NumT buffer[BLOCK_SIZE];
  size_t offset = 0;
  size_t i;
  size_t data_size = sizeof(NumT);

  // Open the event file
  std::ifstream file(event_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw std::runtime_error("Failed opening file: "+event_file);
    }

  // Determine the file and buffer size
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg() / data_size;
  size_t buffer_size = (file_size < BLOCK_SIZE) ? file_size : BLOCK_SIZE;

  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  while(offset < file_size)
    {
      file.seekg(offset * data_size, std::ios::beg);
      file.read(reinterpret_cast<char *>(buffer), buffer_size * data_size);

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for( i = 0; i < buffer_size; i+=2 )
        {
          // Use pointer arithmetic for speed
          EventData::tof.push_back(*(buffer + i));
          EventData::pixel_id.push_back(*(buffer + i + 1));
        }

      offset += buffer_size;

      // Make sure to not read past EOF
      if(offset+BLOCK_SIZE > file_size)
        {
          buffer_size = file_size-offset;
        }
    }

  // Close event file
  file.close();
}

template <typename NumT>
const vector<NumT> EventData<NumT>::get_tof(void)
{
  return static_cast< const vector<NumT> > (EventData::tof);
}

template <typename NumT>
const vector<NumT> EventData<NumT>::get_pixel_id(void)
{
  return static_cast< const vector<NumT> > (EventData::pixel_id);
}
