#include "utils.hpp"

/*
 * $Id$
 */

using namespace std;
using namespace TCLAP;

/**
 * \brief This function swap endians of an array
 * 
 * \param file_size (INPUT) is the size of the array
 * \param array (INPUT/OUTPUT) is the array to be swapped
*/
void swap_endian (int32_t file_size, 
                  int32_t * array)
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
inline void swap_digit (int32_t & x)
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
 * \param debug (INPUT) is a flag for printing debugging info
*/
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
                           bool debug)
{
  filename = path_filename.substr(path_filename.rfind('/')+1);
  path = path_filename.substr(0,path_filename.rfind('/')+1);
  
  if (path.empty())
    {
      path = ".";
    }

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
                                                  const int32_t n_disp,
                                                  int32_t * &binary_array)
{
  // read event binary array
  FILE *e_file;    //REMOVE if it works
  e_file = fopen(input_file.c_str(), "rb");  //REMOVE if it works
  
  struct stat results; //REMOVE if it works

    if (!stat(input_file.c_str(), &results)==0)
  {
  throw runtime_error("Failed to determine size of event binary file");
  }
  
  // check the file size
  int32_t file_size = results.st_size/SIZEOF_INT32_T;   //REMOVE if it works
  
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


                                           
