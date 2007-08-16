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
void EventData<uint32_t, uint32_t>::read_data(const string & event_file,
                                    const string & pulse_id_file,
                                    const string & bank_file);

template 
void EventData<uint32_t, uint32_t>::write_nexus_file(NexusUtil & nexus_util,
                                           const string & pulse_id_file);

template 
void EventData<uint32_t, uint32_t>::write_nexus_file(NexusUtil & nexus_util);

template 
void EventData<uint32_t, uint32_t>::read_data(const string & event_file,
                                    const string & bank_file);

template 
void EventData<uint32_t, uint32_t>::create_pixel_map(const string & mapping_file);

template 
EventData<uint32_t, uint32_t>::EventData();

template 
EventData<uint32_t, uint32_t>::~EventData();

template<typename EventNumT, typename PulseNumT>
EventData<EventNumT, PulseNumT>::EventData()
{
}

template<typename EventNumT, typename PulseNumT>
EventData<EventNumT, PulseNumT>::~EventData()
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

template<typename EventNumT, typename PulseNumT>
inline e_nx_data_type typename_to_nexus_type()
{
  throw runtime_error("Invalid nexus data type");
}

template <typename EventNumT, typename PulseNumT>
string EventData<EventNumT, PulseNumT>::get_nx_data_name(const e_data_name nx_data_type)
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
void EventData<EventNumT, PulseNumT>::write_attr(NexusUtil & nexus_util, 
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

bool is_positive_int(string str)
{
  int size = str.length();
  if (size == 0)
    {
      return false;
    }
  if (str[0] == '0' && size > 1)
    {
      return false;
    }
  for (int i = 1; i < size; i++)
    {
      if (!isdigit(str[i]))
        {
          return false;
        }
    }
  return true;
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::add_to_bank_map(const string & number, 
                                      const int bank_number)
{
cout << "adding num " << number << endl;
  if (number.empty() || !is_positive_int(number))
    {
      throw runtime_error("Invalid number in arbitrary data: "
                          + number);
    }
  int num = atoi(number.c_str());
  if (num > this->bank_map.size())
    {
      this->bank_map.resize(num + 1);
    }
  this->bank_map[num] = this->banks[bank_number];
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::add_to_bank_map(const string & start, 
                                      const string & stop, 
                                      int bank_number)
{
cout << "adding nums " << start << " - " << stop << endl;
  this->add_to_bank_map(start, stop, "1", bank_number);
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::add_to_bank_map(const string & start, 
                                      const string & stop, 
                                      const string & step, 
                                      const int bank_number)
{
cout << "adding nums " << start << " - " << stop  << " with step " << step << endl;
  if (start.empty() || !is_positive_int(start))
    {
      throw runtime_error("Invalid start number: "
                          + start);
    }
  if (stop.empty() || !is_positive_int(stop))
    {
      throw runtime_error("Invalid stop number: "
                          + stop);
    }
  if (step.empty() || !is_positive_int(step))
    {
      throw runtime_error("Invalid step number: "
                          + step);
    }
  if (start >= stop)
    {
      throw runtime_error(
        "Start number must be less than stop number");
    }
  int start_num = atoi(start.c_str());
  int stop_num = atoi(stop.c_str());
  int step_num = atoi(step.c_str());
  if (stop_num > this->bank_map.size())
    {
      this->bank_map.resize(stop_num + 1);
    }
  for (int i = start_num; i < stop_num; i+=step_num)
    {
      this->bank_map[i] = this->banks[bank_number];
    }
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::create_arbitrary(xmlNodePtr bank_node,
                                       int bank_number)
{
  if (bank_node->children == NULL ||
      bank_node->children->content == NULL)
    {
      throw runtime_error("No data found in arbitrary list");
    }
  else
    {
      string number_str(reinterpret_cast<const char *>
                        (bank_node->children->content));
      int size = number_str.length();
      for (int i = 0; i < size; i++)
        {
          if (isdigit(number_str[i]))
            {
              string first_num_str;
              while(isdigit(number_str[i]))
                {
                  first_num_str.push_back(number_str[i]);
                  i++;
                  if (i == size)
                    {
                      this->add_to_bank_map(first_num_str, bank_number);
                      return;
                    }
                }
              while(isspace(number_str[i]))
                {
                  i++;
                  if (i == size)
                    {
                      return;
                    }
                }
              if (number_str[i] == '-')
                {
                  string second_num_str;
                  i++;
                  if (i == size)
                    {
                      throw runtime_error("Invalid data in arbitrary data");
                    }
                  while(isspace(number_str[i]))
                    {
                      i++;
                      if (i == size)
                        {
                          throw runtime_error("Invalid data in arbitrary data");
                        }
                    }
                  if (!isdigit(number_str[i]))
                    {
                      throw runtime_error("Invalid data in arbitrary data");
                    }
                  while(i != size && isdigit(number_str[i]))
                    {
                      second_num_str.push_back(number_str[i]);
                      i++;
                    }
                  // Add the first through the second number, not including the second
                  this->add_to_bank_map(first_num_str, second_num_str, bank_number);
                  // Add the second separately
                  this->add_to_bank_map(second_num_str, bank_number);
                }
              else if (number_str[i] == ',')
                {
                  this->add_to_bank_map(first_num_str, bank_number);
                }
              else
                {
                  throw runtime_error("Invalid character found in arbitrary data: "
                                      + number_str[i]);
                }
            }
          else if (!isspace(number_str[i]))
            {
              throw runtime_error("Invalid character found in arbitrary data: "
                                  + number_str[i]);
            }
        }
    }
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::create_cont_list(xmlNodePtr bank_node,
                                       int bank_number)
{
  string start;
  string stop;
  if (bank_number == -1)
    {
      throw runtime_error(
        "Bank number must be specified before step list");
    }
  xmlNodePtr cont_list_node;
  for (cont_list_node = bank_node->children; cont_list_node;
       cont_list_node = cont_list_node->next)
    {
      if (xmlStrcmp(cont_list_node->name,
          (const xmlChar *)"start") == 0)
        {
          if(cont_list_node->children == NULL ||
             cont_list_node->children->content == NULL)
            {
              throw runtime_error("No start number found");
            }
          start = reinterpret_cast<const char *>
                    (cont_list_node->children->content);
        }
      else if (xmlStrcmp(cont_list_node->name,
               (const xmlChar *)"stop") == 0)
        {
          if(cont_list_node->children == NULL ||
             cont_list_node->children->content == NULL)
            {
              throw runtime_error("No stop number found");
            }
          stop = reinterpret_cast<const char *>
                  (cont_list_node->children->content);
        }
    }
  
  // Fill in a continuous list for the bank map once
  // valid numbers have been found
  this->add_to_bank_map(start, stop, bank_number);
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::create_step_list(xmlNodePtr bank_node,
                                       int bank_number)
{
  string start;
  string stop;
  string step;
  if (bank_number == -1)
    {
      throw runtime_error(
        "Bank number must be specified before step list");
    }
  xmlNodePtr cont_list_node;
  for (cont_list_node = bank_node->children; cont_list_node;
       cont_list_node = cont_list_node->next)
    {
      if (xmlStrcmp(cont_list_node->name,
          (const xmlChar *)"start") == 0)
        {
          if(cont_list_node->children == NULL ||
             cont_list_node->children->content == NULL)
            {
              throw runtime_error("No start number found");
            }
          start = reinterpret_cast<const char *>
                  (cont_list_node->children->content);
        }
      else if (xmlStrcmp(cont_list_node->name,
               (const xmlChar *)"step") == 0)
        {
          if(cont_list_node->children == NULL ||
             cont_list_node->children->content == NULL)
            {
              throw runtime_error("No step number found");
            }
          step = reinterpret_cast<const char *>
                  (cont_list_node->children->content);
        }
      else if (xmlStrcmp(cont_list_node->name,
               (const xmlChar *)"stop") == 0)
        {
          if(cont_list_node->children == NULL ||
             cont_list_node->children->content == NULL)
            {
              throw runtime_error("No stop number found");
            }
          stop = reinterpret_cast<const char *>
                  (cont_list_node->children->content);
        }
    }

  // Fill in a step list for the bank map once
  // valid numbers have been found
  this->add_to_bank_map(start, stop, step, bank_number);
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::parse_bank_file(const string & bank_file)
{
  xmlDocPtr doc = NULL;
  xmlLineNumbersDefault(1);
  doc = xmlReadFile(bank_file.c_str(), NULL, 0);
  if (doc == NULL)
    {
      throw runtime_error("Could not read bank configuration file: " 
                          + bank_file);
    }

  xmlNodePtr cur_node = xmlDocGetRootElement(doc);
  int max_bank_number = -1;
  int bank_number = -1;

  for (cur_node = cur_node->children; cur_node;
       cur_node = cur_node->next) 
    {
      xmlNodePtr bank_node;
      for (bank_node = cur_node->children; bank_node;
           bank_node = bank_node->next)
        {
          if (xmlStrcmp(bank_node->name, 
              (const xmlChar *)"number") == 0)
            {
              // When a valid bank number is found, push it on
              // the bank numbers vector
              if(bank_node->children == NULL ||
                 bank_node->children->content == NULL)
                {
                  throw runtime_error("No step number found");
                }
              string number_str = reinterpret_cast<const char *>
                             (bank_node->children->content);
              if (!is_positive_int(number_str))
                {
                  throw runtime_error("Invalid number: "
                                      + number_str);
                }
              bank_number = atoi(number_str.c_str());
              if (bank_number > max_bank_number) 
                { 
                  max_bank_number = bank_number;
                  this->banks.resize(max_bank_number + 1);
                }
              this->bank_numbers.push_back(
                bank_number);
              this->banks[bank_number] = new Bank<EventNumT, PulseNumT>();
            }
          else if (xmlStrcmp(bank_node->name,
                   (const xmlChar *)"step_list") == 0)
            {
              create_step_list(bank_node, bank_number);
              break;
            }
          else if (xmlStrcmp(bank_node->name, 
                   (const xmlChar *)"continuous_list") == 0)
            {
              create_cont_list(bank_node, bank_number);
              break;
            }
          else if (xmlStrcmp(bank_node->name,
                   (const xmlChar *)"arbitrary") == 0)
            {
              create_arbitrary(bank_node, bank_number);
              break;
            }
        }
      bank_number = -1;
    }

  if (max_bank_number == -1)
    {
      throw runtime_error("No banks found in bank configuration");
    }

  xmlFreeDoc(doc);
  xmlCleanupParser();
}

template <typename EventNumT, typename PulseNumT>
const string & EventData<EventNumT, PulseNumT>::get_pulse_time_offset(void)
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
void EventData<EventNumT, PulseNumT>::write_nexus_file(NexusUtil & nexus_util)
{
  // First layout the nexus file
  nexus_util.make_group("entry", "NXentry");
  nexus_util.open_group("entry", "NXentry");
  int size = bank_numbers.size();
  for (int i = 0; i < size; i++)
    { 
      stringstream bank_num;
      bank_num << "bank" << this->bank_numbers[i];
      nexus_util.make_group(bank_num.str(), "NXevent_data");
      nexus_util.open_group(bank_num.str(), "NXevent_data");
      nexus_util.close_group();
    }
  nexus_util.close_group();
  // Write out each bank's information
  size = this->bank_numbers.size();
  for (int i = 0; i < size; i++)
    {
      if (this->banks[bank_numbers[i]]->tof.size() > 0)
        {
          this->write_data(nexus_util, TOF, this->bank_numbers[i]);
          this->write_data(nexus_util, PIXEL_ID, this->bank_numbers[i]);
          this->write_attr(nexus_util, "units", "10^-7second", 
                           TOF, this->bank_numbers[i]);
        }
    }
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::write_nexus_file(NexusUtil & nexus_util, 
                                       const string & pulse_id_file)
{
  // First layout the nexus file
  nexus_util.make_group("entry", "NXentry");
  nexus_util.open_group("entry", "NXentry");
  int size = bank_numbers.size();
  for (int i = 0; i < size; i++)
    { 
      stringstream bank_num;
      bank_num << "bank" << this->bank_numbers[i];
      nexus_util.make_group(bank_num.str(), "NXevent_data");
      nexus_util.open_group(bank_num.str(), "NXevent_data");
      nexus_util.close_group();
    }
  nexus_util.close_group();
  
  // Write out each bank's information
  size = this->bank_numbers.size();
  for (int i = 0; i < size; i++)
    {
      if (this->banks[this->bank_numbers[i]]->tof.size() > 0)
        {
          this->write_data(nexus_util, TOF, this->bank_numbers[i]);
          this->write_data(nexus_util, PIXEL_ID, this->bank_numbers[i]);
          this->write_data(nexus_util, PULSE_TIME, this->bank_numbers[i]);
          this->write_data(nexus_util, EVENTS_PER_PULSE, this->bank_numbers[i]);
          this->write_attr(nexus_util, "units", "10^-7second", 
                           TOF, this->bank_numbers[i]);
          this->write_attr(nexus_util, "units", "10^-9second", 
                           PULSE_TIME, this->bank_numbers[i]);
          this->write_attr(nexus_util, "offset", this->get_pulse_time_offset(), 
                           PULSE_TIME, this->bank_numbers[i]);
        }
    }
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::open_bank(NexusUtil & nexus_util,
                                const int bank_number)
{
  stringstream bank_num;
  bank_num << "/entry/bank" << bank_number;
  nexus_util.open_path(bank_num.str());
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::write_private_data(NexusUtil & nexus_util,
                                         vector<uint32_t> & nx_data, 
                                         string & data_name,
                                         const int bank_number)
{
  int dimensions = nx_data.size();
  
  // Get the nexus data type of the template
  e_nx_data_type nexus_data_type = typename_to_nexus_type<EventNumT>();
  this->open_bank(nexus_util, bank_number);
  nexus_util.make_data(data_name, nexus_data_type, 1, &dimensions);
  nexus_util.open_data(data_name);
  nexus_util.put_data_with_slabs(nx_data, 16777215);
}

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::write_data(NexusUtil & nexus_util, 
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
                               this->banks[bank_number]->tof, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == PIXEL_ID)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->pixel_id, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == PULSE_TIME)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->pulse_time, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == EVENTS_PER_PULSE)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->events_per_pulse, 
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
void EventData<EventNumT, PulseNumT>::create_pixel_map(const string & mapping_file)
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

string seconds_to_iso8601(uint32_t seconds)
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

template <typename EventNumT, typename PulseNumT>
void EventData<EventNumT, PulseNumT>::read_data(const string & event_file, 
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
  this->parse_bank_file(bank_file);

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
          if ((static_cast<EventNumT>(event.pixel_id) & EventNexus::ERROR) != EventNexus::ERROR)
            {
              // Use pointer arithmetic for speed
              Bank<EventNumT, PulseNumT> *bank = 
                this->bank_map[static_cast<EventNumT>(event.pixel_id)];
             
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
void EventData<EventNumT, PulseNumT>::read_data(const string & event_file, 
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
  PulseNumT event_time_offset = static_cast<PulseNumT>(pulse.nanoseconds);  

  pulse_buf_i++;
  pulse = *(pulse_buffer + pulse_buf_i);

  // Since the first pulse offset is zero and doesn't matter, skip to the 
  // next one and start with it.
  PulseNumT pulse_index = static_cast<PulseNumT>(pulse.index);

  // Parse configuration file and read in the bank map
  this->parse_bank_file(bank_file);

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
      for(size_t event_buf_i = 0; event_buf_i < event_buffer_size; event_buf_i++)
        {
          // If the event_number is the same as the pulse index, then read from the 
          // pulse id buffer to get a new event time and pulse index
          if (event_number == pulse_index)
            {
              event_time_offset = static_cast<PulseNumT> 
                (((pulse.seconds * EventNexus::NANOSECS_PER_SEC) + pulse.nanoseconds)
                   - ((init_seconds * EventNexus::NANOSECS_PER_SEC)));

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
                this->bank_map[static_cast<EventNumT>(event.pixel_id)];
             
              // Place the pixel id and time of flight in the appropriate bank
              bank->tof.push_back(static_cast<EventNumT>(event.tof));
              bank->pixel_id.push_back(
                this->pixel_id_map[static_cast<EventNumT>(event.pixel_id)]);
             
              // If the bank has no pulse index or if a new event time has been
              // encountered, start with 1 as the events per pulse, and push back a 
              // new event time
              if (bank->pulse_index == -1 ||
                  event_time_offset !=
                  bank->pulse_time[bank->pulse_index])
                {
                  bank->pulse_index++;
                  bank->events_per_pulse.push_back(1);
                  bank->pulse_time.push_back(event_time_offset);
                }
              // If the event is still in the same pulse time, then simply increment
              // the event number for that pulse time
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
