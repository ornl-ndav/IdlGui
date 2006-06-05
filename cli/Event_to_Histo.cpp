#include "Event_to_Histo.hpp"

/*
 * $Id: Event_to_Histo.cpp 28 2006-05-02 17:45:45Z j35 $
 */

using namespace std;
using namespace TCLAP;

/*******************************************
/Initialize the array
/*******************************************/
void initialize_array(int32_t * histo_array, 
                      const int size)
{
  for (int32_t i=0 ; i<size ; ++i)
    {
      histo_array[i]=0;
     }
  
  return;   
}

// create histo binary data array
void generate_histo(const int32_t file_size,
                    const int32_t new_Nt,
                    const int32_t pixelnumber,
                    const int32_t time_rebin,
                    const int32_t time_bin,
                    const int32_t * binary_array,
                    const int32_t bin_width,
                    int32_t * histo_array,
                    const bool debug)
{
  int32_t pixelid;
  int32_t time_stamp;

  for (size_t i=0 ; i<file_size/2; i++)
    {
      pixelid = binary_array[2*i+1];
      time_stamp = int32_t(floor((binary_array[2*i]/10)/time_rebin));
      
      if (pixelid<0 || 
          pixelid>pixelnumber ||
          time_stamp<0 ||
          time_stamp>(time_bin*bin_width))
        {
          continue;
        }
      histo_array[time_stamp+pixelid*new_Nt]+=1;
    }
  
  return;
}

int32_t main(int32_t argc, char *argv[])
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

      SwitchArg swapiSwitch ("", "swap_input", 
                            "Flag for swapping data of input file",
                            false, cmd);
      
      SwitchArg swapoSwitch ("", "swap_output",
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

      ValueArg<int32_t> binwidth("w", "bin_width",
                                 "input binary file time bin width",
                                 false, 100, "width of time bin", cmd);

      UnlabeledMultiArg<string> event_file_vector("event_file",
                                            "Name of the event file",
                                            "filename", cmd);

      SwitchArg showDataArg("o", "showdata", "Print the values in the file",
                            false, cmd);
      
      ValueArg<int32_t> n_values("n", "input_file_values",
                               "number of values of input files to print out",
                                 false, 5, "values to output", cmd);

      // Parse the command-line
      cmd.parse(argc, argv);
      
      // isolate path from file name and create output file name
      string input_filename;
      string output_filename("");
      string path; 
      vector<string> input_file_vector = event_file_vector.getValue();
      string input_file = input_file_vector[0];
      bool debug = debugSwitch.getValue();
      
      path_input_output_file_names(input_file,
                                   input_filename,
                                   path,
                                   altoutpath.getValue(),
                                   output_filename,
                                   debug);

      int32_t file_size;
      int32_t * binary_array;
      file_size = read_event_file_and_populate_binary_array(input_file,
                                                            input_filename,
                                                            swapiSwitch.getValue(),
                                                            debug,
                                                            n_values.getValue(),
                                                            binary_array);

      // allocate memory for the histo array
      int32_t time_bin = timebin.getValue();
      int32_t time_rebin = timerebin.getValue();
      int32_t pixel_number = pixelnumber.getValue();

      //initialize array
      int32_t new_Nt = int32_t(floor((time_bin*100)/time_rebin));
      int32_t histo_array_size = new_Nt * pixel_number;
      int32_t * histo_array = new int32_t [histo_array_size];

      initialize_array(histo_array,
                       histo_array_size);
      
      // and create histo binary data array
      generate_histo(file_size,
                     new_Nt,
                     pixelnumber.getValue(),
                     time_bin,
                     time_rebin,
                     binary_array,
                     binwidth.getValue(),
                     histo_array,
                     debug);

      if(swapoSwitch.getValue())
        {
          swap_endian(histo_array_size, histo_array);
        }

      if(showDataArg.getValue())
        {
          
        }

      // write new histogram file
      std::ofstream histo_file(output_filename.c_str(),
                               std::ios::binary);
      histo_file.write((char*)(histo_array),
                       SIZEOF_INT32_T*histo_array_size);
      histo_file.close();

      delete histo_array;
      delete binary_array;

    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}


                        
