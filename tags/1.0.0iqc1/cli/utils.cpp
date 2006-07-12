/*
 *                       Histogramming Tools
 *           A part of the SNS Analysis Software Suite.
 *
 *                  Spallation Neutron Source
 *          Oak Ridge National Laboratory, Oak Ridge TN.
 *
 *
 *                             NOTICE
 *
 * For this software and its associated documentation, permission is granted
 * to reproduce, prepare derivative works, and distribute copies to the public
 * for any purpose and without fee.
 *
 * This material was prepared as an account of work sponsored by an agency of
 * the United States Government.  Neither the United States Government nor the
 * United States Department of Energy, nor any of their employees, makes any
 * warranty, express or implied, or assumes any legal liability or
 * responsibility for the accuracy, completeness, or usefulness of any
 * information, apparatus, product, or process disclosed, or represents that
 * its use would not infringe privately owned rights.
 *
 */

/*
 * $Id$
 * 
 * \file utils.cpp
 */

#include "utils.hpp"

using namespace std;
using namespace TCLAP;

/**
 * \brief This function swap endians of an array
 * 
 * \param file_size (INPUT) is the size of the array
 * \param array (INPUT/OUTPUT) is the array to be swapped
*/
template <typename NumT>
void swap_endian (const int32_t file_size, 
                  NumT * array)
{
  for (int32_t j=0; j<file_size; ++j)
    {
      swap_digit(array[j]);
    }
  
  return;
}

/**
 * \brief This function swap endians of digits
 *
 * \param x (INPUT/OUTPUT) is the digit to be swapped
 */
template <typename NumT>
inline void swap_digit (NumT & x)
{
  x = ((x>>24) & 0x000000FF) |
    ((x<<8) & 0x00FF0000) |
    ((x>>8) & 0x0000FF00) |
    ((x<<24) & 0xFF000000);
}

/**
 * \brief This function displays the n first element of an array
 *
 * \param array (INPUT) is the array for which we need to display
 * the first n elements
 * \param n_disp (INPUT) is the number of element to display
 * \param string_message (INPUT) is the message to display before the n_disp
 * elements
 */
void print32_t_n_first_data(const int32_t * array,
                            const int32_t n_disp,
                            const string message)
{
  cout << message << endl;
  for (size_t i=0 ; i<n_disp ; ++i)
    {
      cout << "\tdata[" << i << "]= " << array[i]<<endl;
    }
  
  return;
}

/**
 * \brief This function parse the name of the event binary file and 
 * parse it to isolate the path from the name of the file
 * 
 * \param path_filename (INPUT) is the complete name of the event binary file
 * \param filename (INPUT) is the name of the file (without the path part)
 * \param path (INPUT) is the path to the file (without the name part)
 * \param alternate_path (INPUT) is the alternate path for the output file
 * \param output_filename (OUTPUT) is the output file name with its path
 * \param output_debug_filename (OUTPUT) is the output file name of the
 * debugging file
 * \param debug (INPUT) is a flag for printing debugging info
*/
void path_input_output_file_names(string & path_filename,
                                  string & filename,
                                  string & path,
                                  string & alternate_path,
                                  string & output_filename,
                                  string & output_debug_filename,
                                  const bool debug)
{
  // Parse input file name (path + input_file_name)
  parse_input_file_name(path_filename,
                        filename,
                        path,
                        debug);

  // Produce output file name (path or alternate_path + output_file_name)
  produce_output_file_name(filename,
                           path,
                           alternate_path,
                           output_filename,
                           debug);
               
  return;
}

/**
 * \brief This function isolate the path from the file name
 *
 * \param path_filename (INPUT) is the complete name of the input file 
 * (path + name)
 * \param filename (OUTPUT) is the name part only of the input file
 * \param path (OUTPUT) is the path name only of the input file
 * \param debug (INPUT) is a flag for printing debugging info
 */
void parse_input_file_name(string & path_filename,
                           string & filename,
                           string & path,
                           const bool debug)
{
  filename = path_filename.substr(path_filename.rfind('/')+1);
  path = path_filename.substr(0,path_filename.rfind('/')+1);
  
  if (path.empty())
    {
      path = ".";
    }

  if(debug)
    {
      cout << "**In parse_input_file_name**\n\n";
      cout << "   path_filename : " << path_filename << endl;
      cout << "   filename      : " << filename << endl;
      cout << "   path          : " << path << endl<<endl;
    }

  return;
}

/**
 * \brief This function produce the complete name of the output file
 * 
 * \param filename (INPUT) is the name part only of the input file
 * \param path (INPUT) is the path part only of the input file
 * \param alternate_path (INPUT) is the alternate path provided on the 
 * command line for the output file name
 * \param output_filename (OUTPUT) is  the complete name (path + name) of the
 * output file
 * \param debug (INPUT) is a flag for printing debugging info
*/
void produce_output_file_name(string & filename,
                              string & path,
                              string & alternate_path,
                              string & output_filename,
                              const bool debug)
{
  string outfile = filename.substr(0,filename.rfind("event"));
  outfile = outfile.append(HISTO_FILE_TAG);
  string local_path("");

  if (alternate_path != "")
    {
      local_path = alternate_path;
    }
  else
    {
      local_path = path;
    }

  output_filename.append(local_path);
  output_filename.append("/");
  output_filename.append(outfile);
  
  if (debug)
    {
      cout << endl;
      cout << "**In produce_output_file_name**\n\n";
      cout << "   outfile         : " << outfile << endl;
      cout << "   local_path      : " << local_path << endl;
      cout << "   output_filename : " << output_filename << endl<<endl;
    }

  return;
}

/**
 * \brief This function read the event binary file and populate the 
 * binary_array with its values
 * 
 * \param input_file (INPUT) is the name of the event binary file
 * \param input_filename (INPUT) is the complete name of the event binary file
 * \param swap_input (INPUT) is a flag that trigger the swapping of the data
 * coming from the event binary file
 * \param debug (INPUT) is a flag for printing debugging info
 * \param n_disp (INPUT) is the number of element to display for debugging
 * purpose only
 * \param binary_array (OUTPUT) is the array of the event binary data
 */
int32_t read_event_file_and_populate_binary_array(const string & input_file,
                                                  const string & 
                                                  input_filename,
                                                  const bool swap_input,
                                                  const bool debug,
                                                  int32_t * &binary_array)
{
  // read event binary array
  ifstream file(input_file.c_str(), ios::in|ios::binary|ios::ate);
  ifstream::pos_type file_size;

  if (!file.is_open())
    {
      throw runtime_error("Failed opening event binary file: \"" + 
                          input_file + "\"\n");
    }
  
  file_size = file.tellg();
  try
    {
      binary_array = new int32_t [file_size];
    }
  catch (bad_alloc &)
    {
      cerr << "Error allocating memory." << endl;
    }
  file.seekg(0,ios::beg);
  
  // transfer the data from the event binary file int32_to binary_array
  file.read(reinterpret_cast<char *>(binary_array),file_size);
  file.close();
  
  // displays the n_disp first values of the event binary file
  string message;
  
  if(swap_input)
    {
      if(debug)
        {
          message="\n**Before swapping the data**\n";
          print32_t_n_first_data(binary_array, 10, message);
        }
      
      swap_endian(file_size, binary_array);
      
      if(debug)
        {
          message="\n**After swapping the data**\n";
          print32_t_n_first_data(binary_array, 10, message);
        }
    }
  else
    {
      message="**10 first values of " + input_filename + "\n";
    }
  
  return file_size;
}

                                           
