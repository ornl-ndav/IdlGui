#include "Event_to_Histo.hpp"

/*
 * $Id: Event_to_Histo.cpp 28 2006-05-02 17:45:45Z j35 $
 */

using namespace std;
using namespace TCLAP;

int main(int argc, char *argv[])
{
  try
    {
      // Setup the command-line parser object
      CmdLine cmd("Command line description message", ' ', VERSION_TAG);

      // Add command-line options
      ValueArg<string> altoutpath("a", "alternate_output", 
                                  "Alternate path for output file",
                                  false, "", "path", cmd);

      SwitchArg debugSwitch("d", "debug", "Flag for debugging program",
                            false, cmd);

      SwitchArg swapiSwitch ("i", "swap_input", 
                            "Flag for swapping data of input file",
                            false, cmd);
      
      SwitchArg swapoSwitch ("o", "swap_output",
                             "Flag for swapping data of output file",
                             false, cmd);

      ValueArg<int32_t> pixelnumber ("p", "number_of_pixels",
                                     "Number of pixels for this run",
                                     true, -1, "pixel number", cmd);

      ValueArg<int32_t> timebin("t", "time_bin", 
                                "Number of time bin in event file",
                                true, -1, "time bin number", cmd);

      ValueArg<int32_t> timerebin("l","linear",
                                   "size of rebin linear time bin",
                                   true, -1, "new linear time bin", cmd);

      ValueArg<string> event_file("f", "event", "Name of the event file", 
                              true, "event.dat", "filename", cmd);

      ValueArg<int32_t> n_values("n", "output_value",
                                 "number of values of files to print out",
                                 false, 5, "values to output", cmd);

      // Parse the command-line
      cmd.parse(argc, argv);
      
      // isolate path from file name and create output file name
      string input_filename;
      string output_filename("");
      string path; 
      string input_file = event_file.getValue();
      bool debug = debugSwitch.getValue();
      
      path_input_output_file_names(input_file,
                                   input_filename,
                                   path,
                                   altoutpath.getValue(),
                                   output_filename,
                                   debug);

      // read event binary array
      FILE *e_file;
      e_file = fopen(input_file.c_str(), "rb");

      struct stat results;

      if (!stat(input_file.c_str(), &results)==0)
        {
          throw runtime_error("Failed to determine size of event binary file");
        }
      
      int file_size = results.st_size/sizeof(int32_t);

      // allocate memory for the binary array
      int32_t * binary_array = new int32_t [file_size];
      
      // transfer the data from the event binary file into binary_array
      fread(&binary_array[0], 
            sizeof(binary_array[0]),
            file_size,
            e_file);

      // displays the n_disp first values of the event binary file
      int n_disp = n_values.getValue();
      string message;
      if(debug)
        {
          if (swapiSwitch.getValue())
            {
              message = "\nBefore swapping the data";
            }
          else
            {
              message = n_disp + " first values of " + input_filename +"\n"; 
            }
          print_n_first_data(binary_array, 
                             n_disp,
                             message);
        }

      if (swapiSwitch.getValue())
        {
          swap_endian(file_size, binary_array);
        }

      if(debug)
        {
          if (swapiSwitch.getValue())
            {
              message = "\nAfter swapping the data";
            }
          else
            {
              message = n_disp + " first values of " + input_filename +"\n"; 
            }
          print_n_first_data(binary_array, 
                             n_disp,
                             message);
        }

      // allocate memory for the histo array
      int32_t time_bin = timebin.getValue();
      int32_t time_rebin = timerebin.getValue();
      int32_t pixel_number = pixelnumber.getValue();

      //initialize array
      int new_Nt = int(floor((time_bin*100)/time_rebin));
      int32_t histo_array_size = new_Nt * pixel_number;
      int32_t * histo_array = new int32_t [histo_array_size];

      initialize_array(histo_array,
                       histo_array_size);
      
      // and create histo binary data array
      generate_histo(file_size,
                     new_Nt,
                     pixelnumber.getValue(),
                     time_rebin,
                     binary_array,
                     histo_array,
                     debug);

      if(debug)
        {
          message = "\nhisto_array";
          print_n_first_data(histo_array, 
                             n_disp,
                             message);
        }

      if (swapoSwitch.getValue())
        {
          swap_endian(histo_array_size, histo_array);
        }

      // write new histogram file
      std::ofstream histo_file(output_filename.c_str(),
                               std::ios::binary);
      histo_file.write((char*)(histo_array),
                       sizeof(histo_array)*histo_array_size);
      histo_file.close();

    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }


  return 0;
}

/*********************************************
/Loop through BinaryArray to swap all endians
/********************************************/
void swap_endian (int file_size, int32_t * BinaryArray)
{
  for (int j=0; j<file_size; ++j)
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

/*******************************************
/Initialize the array
/*******************************************/
void initialize_array(int32_t * histo_array, 
                      const int size)
{
  for (int i=0 ; i<size ; ++i)
    {
      histo_array[i]=0;
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

void print_n_first_data(const int32_t * binary_array,
                        const int n_disp,
                        const string message)
{
  cout << message << endl;
  for (size_t i=0 ; i<n_disp ; ++i)
    {
      cout << "\tdata[" << i << "]= " << binary_array[i]<<endl;
    }
  
  return;
}

// create histo binary data array
void generate_histo(const int file_size,
                    const int new_Nt,
                    const int32_t pixelnumber,
                    const int32_t time_rebin,
                    const int32_t * binary_array,
                    int32_t * histo_array,
                    const bool debug)
{
  int pixelid;
  int time_stamp;

  for (size_t i=0 ; i<file_size/2; i++)
    {
      pixelid = binary_array[2*i+1];
      time_stamp = int(floor((binary_array[2*i]/10)/time_rebin));
      histo_array[time_stamp+pixelid*new_Nt]+=1;
    }
  
  return;
}


                        
