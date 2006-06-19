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

#include "Event_to_Histo.hpp"

/*
 * $Id: Event_to_Histo.cpp 28 2006-05-02 17:45:45Z j35 $
 */

using namespace std;
using namespace TCLAP;

/**
 * \brief This function initializes an array
 * 
 * \param histo_array the array to be initialized
 * \param size the size of the array
 *
 */
void initialize_array(uint32_t * histo_array, 
                      const int size)
{
  for (int32_t i=0 ; i<size ; ++i)
    {
      histo_array[i]=0;
     }
  
  return;   
}

/**
 * \brief This function generates the final histogram array
 *
 * \param file_size (INPUT) is the size of the file to be read
 * \param new_Nt (INPUT) is the new number of time bins
 * \param pixel_number (INPUT) is the number of pixelids
 * \param time_rebin_width (INPUT) is the new time bin width
 * \param binary_array (INPUT) is the array of values coming from the event
 *  binary file
 * \param histo_array (OUTPUT) is the histogram array
 * \param histo_array_size (INPUT) is the size of the histogram array
 * \param debug (INPUT) is a switch that trigger or not the debugging tools
 */
void generate_histo(const int32_t file_size,
                    const int32_t new_Nt,
                    const int32_t pixelnumber,
                    const int32_t time_rebin_width,
                    const int32_t * binary_array,
                    uint32_t * histo_array,
                    const int32_t histo_array_size,
                    const bool debug)
{
  int32_t pixelid;
  int32_t time_stamp;

  //initialize histo array
  initialize_array(histo_array,
                   histo_array_size);

  //loop over entire binary file data
  for (size_t i=0 ; i<file_size/2; i++)
  {
      pixelid = binary_array[2*i+1];
      time_stamp = int32_t(floor((binary_array[2*i]/10)/time_rebin_width));

      //remove data that are oustide the scope of range
      if (pixelid<0 || 
          pixelid>pixelnumber ||
          time_stamp<0 ||
          time_stamp>(time_rebin_width*(new_Nt-1)))
        {
          continue;
        }
      //record data that is inside the scope of range
      histo_array[time_stamp+pixelid*new_Nt]+=1;
  }
  
  return;
}

/**
 * \brief This program takes an event binary file and according to the 
 * arguments provided, creates a histo binary file.
 */
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

      ValueArg<int32_t> timebinnumber("t", "time_bin_number", 
                                      "Number of time bin in event file",
                                      true, -1, "time bin number", cmd);

      ValueArg<int32_t> timerebinwidth("l","linear",
                                       "width of rebin linear time bin",
                                       true, -1, "new linear time bin", cmd);
      
      ValueArg<int32_t> timebinwidth("w", "time_bin_width",
                                     "input binary file time bin width",
                                     false, 100, 
                                     "width of event file time bin", cmd);
      
      UnlabeledMultiArg<string> event_file_vector("event_file",
                                                  "Name of the event file",
                                                  "filename", cmd);
      
      // Parse the command-line
      cmd.parse(argc, argv);

      // Create string vector of all input file names
      vector<string> input_file_vector = event_file_vector.getValue();

      bool debug = debugSwitch.getValue();

      // loop over all input files names
      for (size_t i=0 ; i<input_file_vector.size() ; ++i)
        {
          string input_filename;
          string output_filename("");
          string output_debug_filename("");
          string path; 
          string input_file = input_file_vector[i];
          
          path_input_output_file_names(input_file,
                                       input_filename,
                                       path,
                                       altoutpath.getValue(),
                                       output_filename,
                                       output_debug_filename,
                                       debug);
          
          // read input file and populate the binary array 
          int32_t file_size;
          int32_t * binary_array;
          
          file_size = 
            read_event_file_and_populate_binary_array(input_file,
                                                      input_filename,
                                                      swapiSwitch.getValue(),
                                                      debug,
                                                      binary_array);
          
          int32_t time_bin_number = timebinnumber.getValue(); 
          int32_t time_rebin_width = timerebinwidth.getValue();
          int32_t pixel_number = pixelnumber.getValue();
          int32_t new_Nt = int32_t(floor(((time_bin_number-1)*
                                          timebinwidth.getValue())
                                         /time_rebin_width)+1);
          int32_t histo_array_size = new_Nt * pixel_number;
          uint32_t * histo_array = new uint32_t [histo_array_size];
          
          
          //generate histo binary data array
          generate_histo(file_size,
                         new_Nt,
                         pixelnumber.getValue(),
                         time_rebin_width,
                         binary_array,
                         histo_array,
                         histo_array_size,
                         debug);
          
          // swap endian of output array (histo_array)
          if(swapoSwitch.getValue())
            {
              swap_endian(histo_array_size, histo_array);
            }
          
          // write new histogram file
          std::ofstream histo_file(output_filename.c_str(),
                                   std::ios::binary);
          histo_file.write((char*)(histo_array),
                           SIZEOF_UINT32_T*histo_array_size);
          histo_file.close();
          
          // free memory allocated to arrays
          delete histo_array;
          delete binary_array;
        }
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}


                        
