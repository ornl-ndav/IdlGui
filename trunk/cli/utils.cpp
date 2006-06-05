#include "utils.hpp"

/*
 * $Id$
 */

using namespace std;
using namespace TCLAP;

/*********************************************
/Loop through BinaryArray to swap all endians
/********************************************/
void swap_endian (int32_t file_size, 
                  int32_t * BinaryArray)
{
  for (int32_t j=0; j<file_size; ++j)
    {
      swap_digit(BinaryArray[j]);
    }
  
  return;
}

/*******************************************
/To swap from little endian to big endian
/*******************************************/
inline void swap_digit (int32_t & x)
{
  x = ((x>>24) & 0x000000FF) |
    ((x<<8) & 0x00FF0000) |
    ((x>>8) & 0x0000FF00) |
    ((x<<24) & 0xFF000000);
}

/*************************************************
/ to plot the n first data of the specified array
/*************************************************/
void print32_t_n_first_data(const int32_t * binary_array,
                        const int32_t n_disp,
                        const string message)
{
  cout << message << endl;
  for (size_t i=0 ; i<n_disp ; ++i)
    {
      cout << "\tdata[" << i << "]= " << binary_array[i]<<endl;
    }
  
  return;
}

/*******************************************
/ Isolate file_name from path+file_name
/ and generate output file name
/*******************************************/
void path_input_output_file_names(string & path_filename,
                                  string & filename,
                                  string & path,
                                  string & alternate_path,
                                  string & output_filename,
                                  bool debug)
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

// Isolate path and file_name from command line argument
void parse_input_file_name(string & path_filename,
                           string & filename,
                           string & path,
                           bool debug)
{
  filename = path_filename.substr(path_filename.rfind('/')+1);
  path = path_filename.substr(0,path_filename.rfind('/')+1);
 
  if(debug)
    {
      cout << "******************************"<<endl;
      cout << "In parse_input_file_name " << endl;
      cout << "   path_filename : " << path_filename << endl;
      cout << "   filename      : " << filename << endl;
      cout << "   path          : " << path << endl;
      cout << "******************************" << endl;
    }

  return;
}

// Generate the name of the output file
void produce_output_file_name(string & filename,
                              string & path,
                              string & alternate_path,
                              string & output_filename,
                              bool debug)
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
      cout << "*********************************"<<endl;
      cout << "In produce_output_file_name " << endl;
      cout << "   outfile         : " << outfile << endl;
      cout << "   local_path      : " << local_path << endl;
      cout << "   output_filename : " << output_filename << endl;
      cout << "*********************************"<<endl;      
    }

  return;
}
