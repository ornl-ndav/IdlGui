#include "bank_data.hpp"
#include <string>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include <locale>
#include <stdexcept>
#include <vector>
#include <iostream>

using std::cout;
using std::endl;
using std::vector;
using std::string;
using std::runtime_error;

template 
BankData<uint32_t, uint32_t>::
BankData();

template 
BankData<uint32_t, uint32_t>::
~BankData();

template
Bank<uint32_t, uint32_t> * BankData<uint32_t, uint32_t>::
get_bank_by_pixel_id(const uint32_t pixel_id);

template
Bank<uint32_t, uint32_t> * BankData<uint32_t, uint32_t>::
get_bank_by_bank_number(int bank_number);

template
void BankData<uint32_t, uint32_t>::
parse_bank_file(const string & bank_file);

template 
BankData<uint32_t, uint64_t>::
BankData();

template 
BankData<uint32_t, uint64_t>::
~BankData();

template
Bank<uint32_t, uint64_t> * BankData<uint32_t, uint64_t>::
get_bank_by_pixel_id(const uint32_t pixel_id);

template
Bank<uint32_t, uint64_t> * BankData<uint32_t, uint64_t>::
get_bank_by_bank_number(int bank_number);

template
void BankData<uint32_t, uint64_t>::
parse_bank_file(const string & bank_file);

template<typename EventNumT, typename PulseNumT>
Bank<EventNumT, PulseNumT> * BankData<EventNumT, PulseNumT>::
get_bank_by_pixel_id(const EventNumT pixel_id)
{
  return this->bank_map[pixel_id];
}

template<typename EventNumT, typename PulseNumT>
Bank<EventNumT, PulseNumT> * BankData<EventNumT, PulseNumT>::
get_bank_by_bank_number(const int bank_number)
{
  return this->banks[bank_number];
}

template<typename EventNumT, typename PulseNumT>
BankData<EventNumT, PulseNumT>::
BankData()
{
}

template<typename EventNumT, typename PulseNumT>
BankData<EventNumT, PulseNumT>::
~BankData()
{
  if (!this->bank_numbers.empty())
    {
      int size = bank_numbers.size();
      for (int i = 0; i < size; i++)
        {
          delete this->banks[this->bank_numbers[i]];
        }
    }
}

void check_positive_int(const string & str)
{
  if (str.empty())
    {
      throw runtime_error("Invalid empty number in bank config");
    }
  int size = str.length();
  for (int i = 0; i < size; i++)
    {
      if (!isdigit(str[i]))
        {
          throw runtime_error("Invalid number in bank config: "
                              + str);
        }
    }
}

void check_xml_content(xmlNodePtr node)
{
  if(node->children == NULL ||
     node->children->content == NULL)
    {
      throw runtime_error("No content found under xml tag: " 
        + string(reinterpret_cast<const char *>(node->name)));
    }
}

template <typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
add_to_bank_map(const string & number,
                const int bank_number)
{
  check_positive_int(number);
  int num = atoi(number.c_str());
  if (num > this->bank_map.size())
    {
      this->bank_map.resize(num + 1);
    }
  this->bank_map[num] = this->banks[bank_number];
}

template <typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
add_to_bank_map(const string & start,
                const string & stop,
                const int bank_number)
{
  this->add_to_bank_map(start, stop, "1", bank_number);
}

template <typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
add_to_bank_map(const string & start,
                const string & stop,
                const string & step,
                const int bank_number)
{
  check_positive_int(start);
  check_positive_int(stop);
  check_positive_int(step);
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

template<typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
create_bank(const int bank_number)
{
  if (bank_number >= this->banks.size())
    {
      this->banks.resize(bank_number + 1);
    }
  this->bank_numbers.push_back(bank_number);
  this->banks[bank_number] = new Bank<EventNumT, PulseNumT>();
}

template<typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
parse_bank_file(const string & bank_file)
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

  for (cur_node = cur_node->children; cur_node;
       cur_node = cur_node->next)
    {
      bool bank_is_found = false;
      xmlNodePtr bank_node;
      for (bank_node = cur_node->children; bank_node;
           bank_node = bank_node->next)
        {
          int bank_number;
          if (xmlStrcmp(bank_node->name,
              (const xmlChar *)"number") == 0)
            {
              // When a valid bank number is found, push it on
              // the bank numbers vector
              check_xml_content(bank_node);
              string number_str = reinterpret_cast<const char *>
                             (bank_node->children->content);
              check_positive_int(number_str);
              bank_number = atoi(number_str.c_str());
              this->create_bank(bank_number);
              bank_is_found = true;
            }
          else if (xmlStrcmp(bank_node->name,
                   (const xmlChar *)"step_list") == 0)
            {
              if (bank_is_found)
                {
                  create_step_list(bank_node, bank_number);
                }
              else
                {
                  throw runtime_error(
                    "Bank number must be specified before step list");
                }
              break;
            }
          else if (xmlStrcmp(bank_node->name,
                   (const xmlChar *)"continuous_list") == 0)
            {
              if (bank_is_found)
                {
                  create_cont_list(bank_node, bank_number);
                }
              else
                {
                  throw runtime_error(
                    "Bank number must be specified before continuous list");
                }
              break;
            }
          else if (xmlStrcmp(bank_node->name,
                   (const xmlChar *)"arbitrary") == 0)
            {
              if (bank_is_found)
                {
                  create_arbitrary(bank_node, bank_number);
                }
              else 
                {
                  throw runtime_error(
                    "Bank number must be specified before arbitrary list");
                }
              break;
            }
        }
    }
  if (this->banks.empty())
    {
      throw runtime_error("No banks found in bank configuration");
    }
  xmlFreeDoc(doc);
  xmlCleanupParser();
}

template <typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
create_step_list(xmlNodePtr bank_node,
                 const int bank_number)
{
  string start;
  string stop;
  string step;
  xmlNodePtr step_list_node;
  for (step_list_node = bank_node->children; step_list_node;
       step_list_node = step_list_node->next)
    {
      if (xmlStrcmp(step_list_node->name,
          (const xmlChar *)"start") == 0)
        {
          check_xml_content(step_list_node);
          start = reinterpret_cast<const char *>
                  (step_list_node->children->content);
        }
      else if (xmlStrcmp(step_list_node->name,
               (const xmlChar *)"step") == 0)
        {
          check_xml_content(step_list_node->children);
          step = reinterpret_cast<const char *>
                  (step_list_node->children->content);
        }
      else if (xmlStrcmp(step_list_node->name,
               (const xmlChar *)"stop") == 0)
        {
          check_xml_content(step_list_node);
          stop = reinterpret_cast<const char *>
                  (step_list_node->children->content);
        }
    }

  // Fill in a step list for the bank map once
  // valid numbers have been found
  this->add_to_bank_map(start, stop, step, bank_number);
}

template <typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
create_cont_list(xmlNodePtr bank_node,
                 const int bank_number)
{
  string start;
  string stop;
  xmlNodePtr cont_list_node;
  for (cont_list_node = bank_node->children; cont_list_node;
       cont_list_node = cont_list_node->next)
    {
      if (xmlStrcmp(cont_list_node->name,
          (const xmlChar *)"start") == 0)
        {
          check_xml_content(cont_list_node);
          start = reinterpret_cast<const char *>
                    (cont_list_node->children->content);
        }
      else if (xmlStrcmp(cont_list_node->name,
               (const xmlChar *)"stop") == 0)
        {
          check_xml_content(cont_list_node);
          stop = reinterpret_cast<const char *>
                  (cont_list_node->children->content);
        }
    }

  // Fill in a continuous list for the bank map once
  // valid numbers have been found
  this->add_to_bank_map(start, stop, bank_number);
}

bool isdelimiter(char c)
{
  if (c == '-' || c == ',')
    {
      return true;
    }
  else
    {
      return false;
    }
}

void validate_arbitrary_data(const string & data)
{
  int size = data.length();
  string prev_sequence;
  bool new_sequence = false;
  vector<char> delimiters;
  bool first_found = false;
  string last_found;
  for (int i = 0; i < size; i++)
    {
      if (isdigit(data[i]))
        {
          if (new_sequence && isdigit(prev_sequence[0]))
            {
              throw runtime_error("Arbitrary data has non delimited numbers");
            }
          prev_sequence = data[i];
          first_found = true;
          new_sequence = false;
        }
      else if (isdelimiter(data[i]))
        {
          if (!first_found)
            {
              throw runtime_error("Arbitrary data starts with a delimiter");
            }
          if (isdelimiter(prev_sequence[0]))
            {
              throw runtime_error("Arbitrary data has two delimiters in a row");
            }
          prev_sequence = data[i];
          delimiters.push_back(data[i]);
          new_sequence = false;
        }
      else if (isspace(data[i]))
        {
          if (!prev_sequence.empty())
            {
              new_sequence = true; 
            }
        }
      else 
        {
          throw runtime_error("Invalid character in arbitrary data");
        }
      if (!isspace(data[i]))
        {
          last_found = data[i];
        }
    }

  if (last_found.empty())
    {
      throw runtime_error("No arbitrary data found");
    }
  if (isdelimiter(last_found[0]))
    {
      throw runtime_error("Arbitrary data ends with a delimiter");
    }

  size = delimiters.size();
  char prev_delimiter;
  for (int i = 0; i < size; i++)
    {
      if (i != 0 && delimiters[i] == '-' &&
          prev_delimiter == '-')
        { 
          throw runtime_error("Only two numbers in arbitrary data may be separated by hyphen");
        }
      prev_delimiter = delimiters[i];
    }
}

template <typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
add_arbitrary_to_bank_map(const string & number_set,
                          const int bank_number)
{
  if (number_set.empty())
    {
      return;
    }
  int size = number_set.length();
  string start_num;
  string end_num;
  bool dash_is_found = false;
  for (int i = 0; i < size; i++)
    {
      if (!isspace(number_set[i]))
        {
          if (number_set[i] == '-')
            {
              dash_is_found = true;
            }
          else if(!dash_is_found)
            {
              start_num.push_back(number_set[i]);
            }
          else
            {
              end_num.push_back(number_set[i]);
            }
        }
    }
  if (end_num.empty())
    {
      this->add_to_bank_map(start_num, bank_number);
    }
  else
    {
      this->add_to_bank_map(start_num, end_num, bank_number);
      this->add_to_bank_map(end_num, bank_number);
    }
}

template <typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::
create_arbitrary(xmlNodePtr bank_node,
                 const int bank_number)
{
  check_xml_content(bank_node);
  string arbitrary_str(reinterpret_cast<const char *>
                        (bank_node->children->content));
  validate_arbitrary_data(arbitrary_str);
  int size = arbitrary_str.length();
  string number_set;
  for (int i = 0; i < size; i++)
    {
      if (arbitrary_str[i] != ',')
        {
          number_set.push_back(arbitrary_str[i]);
        }
      else
        {
          this->add_arbitrary_to_bank_map(number_set, bank_number);
          number_set.clear();
        }
    }
  this->add_arbitrary_to_bank_map(number_set, bank_number);
}
