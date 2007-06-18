/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file EventData.cpp
 *  \brief The implementation for the EventData
 *         class.
 */

#ifndef _IMPLEMENTATION
#define _IMPLEMENTATION

#include "event2nxl.hpp"

using std::ifstream;
using std::runtime_error;

template <typename NumT>
void EventData<NumT>::read_data(const Config &config) 
{
  NumT buffer[BLOCK_SIZE];
  size_t offset = 0;
  size_t i;
  size_t data_size = sizeof(NumT);

  // Open the event file
  ifstream file(config.event_file.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: "+config.event_file);
    }

  // Determine the file and buffer size
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg()/data_size;
  size_t buffer_size = (file_size < BLOCK_SIZE) ? file_size : BLOCK_SIZE;

  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  while(offset < file_size)
    {
      file.seekg(offset*data_size, std::ios::beg);
      file.read(reinterpret_cast<char *>(buffer), buffer_size*data_size);

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for( i = 0; i < buffer_size; i+=2 )
        {
          // Use pointer arithmetic for speed
          EventData::tof.push_back(*(buffer+i));
          EventData::pixel_id.push_back(*(buffer+i+1));
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

#endif
