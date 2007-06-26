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

using std::vector;
using std::string;

// Declaring these functions prevent from having to include 
// event_data.cpp in event_data.hpp
template const vector<uint32_t> EventData<uint32_t>::get_tof(void);
template const vector<uint32_t> EventData<uint32_t>::get_pixel_id(void);
template void EventData<uint32_t>::read_data(const string &, const string &);

template <typename NumT>
void EventData<NumT>::map_pixel_ids(const string &mapping_file, 
                                    std::map<uint32_t, uint32_t> &pixel_id_map)
{
  size_t data_size = sizeof(uint32_t);
  uint32_t mapping_index = 0;
  int32_t buffer[BLOCK_SIZE];
  size_t offset = 0;
  size_t i;

  // Open the mapping file
  std::ifstream file(mapping_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw std::runtime_error("Failed opening file: "+mapping_file);
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
      for( i = 0; i < buffer_size; i++ )
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
}

template <typename NumT>
void EventData<NumT>::read_data(const string &event_file, 
                                const string &mapping_file) 
{
  NumT buffer[BLOCK_SIZE];
  size_t offset = 0;
  size_t i;
  size_t data_size = sizeof(NumT);
  std::map<uint32_t, uint32_t> pixel_id_map;
  std::map<uint32_t, uint32_t>::iterator map_iterator;
  std::map<uint32_t, uint32_t>::iterator map_end;
  bool is_mapped = (mapping_file != "") ? true : false;

  // First create a map if mapping is set
  if (is_mapped)
    {
      map_pixel_ids(mapping_file, pixel_id_map);
      map_end = pixel_id_map.end();
    }

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

          // Map the pixels if necessary
          if (is_mapped && 
             (map_iterator = pixel_id_map.find(*(buffer + i + 1))) != map_end)
            {
              EventData::pixel_id.push_back(map_iterator->second);
            }
          else
            {
              EventData::pixel_id.push_back(*(buffer + i + 1));
            }
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
