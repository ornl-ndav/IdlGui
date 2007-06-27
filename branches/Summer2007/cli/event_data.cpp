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
template void EventData<uint32_t>::read_data(const string &);
template void EventData<uint32_t>::write_data(NexusUtil &, 
                                              const e_data_name);
template void EventData<uint32_t>::write_attr(NexusUtil &,
                                              const string &,
                                              const string &,
                                              const e_data_name);
template void EventData<uint32_t>::map_pixel_ids(const string &);
template EventData<uint32_t>::EventData(const string &);

template<typename NumT>
EventData<NumT>::EventData(const string &path)
{
  data_path = path;
}

template <typename NumT>
inline int EventData<NumT>::typename_to_nexus_type(const int32_t &val)
{
  return NX_INT32;
}

template <typename NumT>
inline int EventData<NumT>::typename_to_nexus_type(const uint32_t &val)
{
  return NX_UINT32;
}

template <typename NumT>
void EventData<NumT>::get_nx_data_values(const e_data_name nx_data_type, 
                                         string &data_name)
{
  if (nx_data_type == TOF)
    {
      data_name = "time_of_flight";
    }
  else if (nx_data_type == PIXEL_ID)
    {
      data_name = "pixel_number";
    }
}

template <typename NumT>
void EventData<NumT>::get_nx_data_values(const e_data_name nx_data_type,
                                         string &data_name,
                                         vector<NumT> &data)
{
  get_nx_data_values(nx_data_type, data_name);
  if (nx_data_type == TOF)
    {
      data = tof;
    }
  else if (nx_data_type == PIXEL_ID)
    {
      data = pixel_id;
    }
}

template <typename NumT>
void EventData<NumT>::write_attr(NexusUtil &nexus_util, 
                                 const string &attr_name,
                                 const string &attr_value,
                                 const e_data_name nx_data_name)
{

  string nx_attr_value(attr_value);
  string data_name;

  get_nx_data_values(nx_data_name, data_name);  

  nexus_util.open_path(data_path + "/" + data_name);
  nexus_util.put_attr(attr_name, &nx_attr_value[0],
                      attr_value.length(), NX_CHAR);
}

template <typename NumT>
void EventData<NumT>::write_data(NexusUtil &nexus_util, 
                                 const e_data_name nx_data_name)
{
  string data_name;
  // Make a non constant variable to pass to nx function
  // to make sure the original is never changed
  vector<NumT> nx_data;
  // Get the size of the data for referencing it
  int dimensions;
  // Get the nexus data type of the template
  NumT type;
  int nexus_data_type = typename_to_nexus_type(type);
  int i = 0;

  nexus_util.open_path(data_path);

  get_nx_data_values(nx_data_name, data_name, nx_data);
  
  dimensions = nx_data.size();
  nexus_util.make_data(data_name, nexus_data_type, 1, &dimensions);
  nexus_util.open_data(data_name);

  // Write all the data to the nexus file
  nexus_util.put_slab(&nx_data[0], &i, &dimensions);
}
 

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
