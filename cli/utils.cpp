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

/*******************************************
/ Generate the name of the output file
/*******************************************/
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

/*******************************************
/ Read event file and create binary_array
/*******************************************/
int32_t read_event_file_and_populate_binary_array(const string & input_file,
                                                  const string & 
                                                  input_filename,
                                                  const bool swap_input,
                                                  const bool debug,
                                                  const int32_t n_disp,
                                                  int32_t * &binary_array)
{
  // read event binary array
  FILE *e_file;
  e_file = fopen(input_file.c_str(), "rb");
  
  struct stat results;
  
  if (!stat(input_file.c_str(), &results)==0)
    {
      throw runtime_error("Failed to determine size of event binary file");
    }
  
  int32_t file_size = results.st_size/SIZEOF_INT32_T;
  
  // allocate memory for the binary array
  binary_array = new int32_t [file_size];
  
  // transfer the data from the event binary file int32_to binary_array
  fread(&binary_array[0], 
        sizeof(binary_array[0]),
        file_size,
        e_file);
  
  // displays the n_disp first values of the event binary file
  string message;

  if(swap_input)
    {
      if(debug)
        {
          message="\nBefore swapping the data\n";
          print32_t_n_first_data(binary_array, n_disp, message);
        }

      swap_endian(file_size, binary_array);
      
      if(debug)
        {
          message="\nAfter swapping the data\n";
          print32_t_n_first_data(binary_array, n_disp, message);
        }
    }
  else
    {
      message=n_disp+" first values of " + input_filename + "\n";
    }
  
  return file_size;
}


                                           
