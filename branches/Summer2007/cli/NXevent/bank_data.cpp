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
BankData<uint32_t, uint32_t>::BankData(const string & bank_file);

template 
BankData<uint32_t, uint32_t>::~BankData();

template
Bank<uint32_t, uint32_t> * BankData<uint32_t, uint32_t>::get_bank_by_pixel_id(const uint32_t pixel_id);

template
Bank<uint32_t, uint32_t> * BankData<uint32_t, uint32_t>::get_bank_by_bank_number(int bank_number);

template<typename EventNumT, typename PulseNumT>
Bank<EventNumT, PulseNumT> * BankData<EventNumT, PulseNumT>::get_bank_by_pixel_id(const EventNumT pixel_id)
{
  return this->bank_map[pixel_id];
}

template<typename EventNumT, typename PulseNumT>
Bank<EventNumT, PulseNumT> * BankData<EventNumT, PulseNumT>::get_bank_by_bank_number(const int bank_number)
{
  return this->banks[bank_number];
}

template<typename EventNumT, typename PulseNumT>
BankData<EventNumT, PulseNumT>::~BankData()
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

bool is_positive_int(string str)
{
  if (str.empty())
    {
      return false;
    }
  int size = str.length();
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
void BankData<EventNumT, PulseNumT>::add_to_bank_map(const string & number,
                                      const int bank_number)
{
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
void BankData<EventNumT, PulseNumT>::add_to_bank_map(const string & start,
                                      const string & stop,
                                      int bank_number)
{
  this->add_to_bank_map(start, stop, "1", bank_number);
}

template <typename EventNumT, typename PulseNumT>
void BankData<EventNumT, PulseNumT>::add_to_bank_map(const string & start,
                                      const string & stop,
                                      const string & step,
                                      const int bank_number)
{
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


template<typename EventNumT, typename PulseNumT>
BankData<EventNumT, PulseNumT>::BankData(const string & bank_file)
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
                  throw runtime_error("No bank number found");
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
void BankData<EventNumT, PulseNumT>::create_step_list(xmlNodePtr bank_node,
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
void BankData<EventNumT, PulseNumT>::create_cont_list(xmlNodePtr bank_node,
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
void BankData<EventNumT, PulseNumT>::create_arbitrary(xmlNodePtr bank_node,
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
