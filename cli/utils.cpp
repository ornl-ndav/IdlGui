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

void print32_t_n_first_data(const int32_t * array,
                            const size_t array_size,
                            const size_t n_disp)
{
  if (n_disp < array_size)
    {
      for (size_t i=0 ; i<n_disp ; ++i)
        {
          cout << "\tarray[" << i << "]= " << array[i]<<endl;
        }
      cout << "\t... \n";
      cout << "\tarray["<<array_size-1<<"]= " << array[array_size-1]<<endl;
    }
  else
    {
      for (size_t i=0 ; i<array_size ; ++i)
        {
          cout << "\tarray[" << i << "]= " << array[i]<<endl;
        }
    }

  return;
}


void path_input_output_file_names(const string & path_filename,
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


void parse_input_file_name(const string & path_filename,
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


void produce_output_file_name(const string & filename,
                              const string & path,
                              const string & alternate_path,
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


size_t read_event_file_and_populate_binary_array(const string & input_file,
                                                  const string & 
                                                  input_filename,
                                                  const size_t n_disp,
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
  size_t array_size = file_size / SIZEOF_INT32_T;

  try
    {
      binary_array = new int32_t [array_size];
    }
  catch (bad_alloc &)
    {
      cerr << "Error allocating memory." << endl;
    }

  file.seekg(0,ios::beg);

  // transfer the data from the event binary file int32_to binary_array
  //  file.read(reinterpret_cast<char *>(binary_array),file_size);
  file.read(reinterpret_cast<char *>(binary_array),file_size);
  file.close();

  // displays the n_disp first values of the event binary file
  string message;
  
  if(debug)
    {
      cout << "\n**" << n_disp;
      cout << " first values and last value of binary_array**\n";
      print32_t_n_first_data(binary_array, array_size, n_disp);
    }

  if(swap_input)
    {
      swap_endian(array_size, binary_array);
      if(debug)
        {
          cout << "\n**After swapping the data**\n";
          print32_t_n_first_data(binary_array, array_size, n_disp);
        }
    }

  return file_size;
}

