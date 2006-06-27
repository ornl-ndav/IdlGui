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
 * $Id: Event_to_Histo.cpp 28 2006-05-02 17:45:45Z j35 $
 *
 * \file Event_to_Histo.cpp
 */

#include "Event_to_Histo.hpp"

using namespace std;
using namespace TCLAP;

/**
 * \brief This function does a binary search of a variable into a given
 * array. It returns the position of the data into the sortedVector or the 
 * closest value inferior to the data. It returns -1 if the data is out of 
 * range.
 *
 * \param sortedVector (INPUT) is the sorted array where to look for the 
 * location of the key
 * \param sortedVector_size (INPUT) is the size of the sorted array
 * \param key (INPUT) is the data to look for
 *
 * \returns It returns the position of the data or of the closest inferior value
 * found in sortedVector. Returns -1 if the data is out of range.
*/
int32_t binarySearch(const vector<float> sortedVector, 
                     const float key)
{
  int sortedVector_size = sortedVector.size();
  int first = 0;
  int last = sortedVector_size;

  //check first if the value is out of range
  if (key > sortedVector[sortedVector_size-1])
    {
      return -1;
    }
  while (first < last-1)
    {
      int mid = (first + last) / 2;
      if (key > sortedVector[mid])
        {
          first = mid;
        }
      else if (key < sortedVector[mid])
       {
         last = mid;
       }
      else
        {
          return (mid);
        }
    }
  return (first);
}

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
 * \param time_bin_vector (INPUT)
 * \param debug (INPUT) is a switch that trigger or not the debugging tools
 */
void generate_histo(const int32_t file_size,
                    const int32_t new_Nt,
                    const int32_t pixelnumber,
                    const int32_t time_rebin_width,
                    const int32_t * binary_array,
                    uint32_t * histo_array,
                    const int32_t histo_array_size,
                    const vector<float> time_bin_vector,
                    const float max_time_bin,
                    const bool debug)
{
  int32_t pixelid;
  int32_t time_stamp;

  //initialize histo array
  initialize_array(histo_array,
                   histo_array_size);

  if (debug)
    {
      cout << "\n\n**In generate_histo**\n\n";
      cout << "\tfile_size= " << file_size << endl;
      cout << "\tnew_Nt= " << new_Nt << endl;
      cout << "\tmax_time_bin= " << max_time_bin << endl;
      cout << "\nLegend:";
      cout << "\t\t#     : index number\n";
      cout << "------\t\t";
      cout << "Pid   : PixelID\n";
      cout << "\t\t    t_ms  : time in micro seconds\n";
      cout << "\t\t    tstamp: time_stamp\n\n";
    }

  //loop over entire binary file data (from 0 to file_size/2 because we use
  //the variable 2*i into the for loop. Like this, the all file is covered.
  for (size_t i=0 ; i<file_size/2; i++) 
  {
      pixelid = binary_array[2*i+1];
      //We need to divide by 10 to go from 100ns to micros
      time_stamp = binarySearch(time_bin_vector,
                                static_cast<float>(binary_array[2*i]/10.));
      if (debug)
        {
          cout << "#" << i << "\t";
          cout << "Pid= " << pixelid <<"\t";
          cout << "t_ms= " << static_cast<float>(binary_array[2*i]/10.)<<"\t";
          cout << "tstamp_value= ";
          cout << static_cast<int>(floor(time_bin_vector[time_stamp]));
          cout << "\ttstamp_position= " << time_stamp;
        }

      //remove data that are oustide the scope of range
      if (pixelid<0 ||                             
          pixelid>pixelnumber ||
          time_stamp<0 ||              //change 0 -> offset here !!!!!!
          time_stamp>(max_time_bin))
        {
          if (debug)
            {
              cout << "......OUT OF RANGE\n";
            }
          continue;
        }
      else
        {
          if (debug)
            {
              cout << "......OK\n";
            }
          //record data that is inside the scope of range
          histo_array[time_stamp+pixelid*new_Nt]+=1;
        }
  }
  return;
}

/**
 * \brief This function creates the vector of a linear time bins widths
 * For example, for a time bin of 25micros, the first values of the vector
 * will be 0, 25, 50, 75....
 *
 * \param max_time_bin (INPUT)
 * \param time_rebin_width (INPUT) is the rebin value
 * \param time_offset (INPUT) is the starting offset time
 * \param debug (INPUT) is a switch that trigger or not the debugging tools
 *
 * \return A vector of the time bin values.
 */
vector<float> generate_linear_time_bin_vector(const float max_time_bin,
                                              const int32_t time_rebin_width,
                                              const int32_t time_offset,
                                              const bool debug)
{
  vector<float> time_bin_vector;
  int32_t i=0;  //use for debugging tool only

  if (debug)
    {
      cout << "\n**Generate linear time bin vector**\n\n";
      cout << "\tmax_time_bin= " << max_time_bin<<endl;
      cout << "\ttime_rebin_width= " << time_rebin_width << endl<<endl;
    } 
  // change t_bin=0 to t_bin=t_bin_offset here !!!!!
  for (size_t t_bin=0; t_bin<=max_time_bin; t_bin+=time_rebin_width)
    {
      time_bin_vector.push_back(static_cast<float>(t_bin));
      if (debug)
        {
          cout << "\ttime_bin_vector["<<i<<"]= "<<time_bin_vector[i]<<endl;
          ++i;
        }
    }
  return time_bin_vector;
}

/**
 * \brief This function creates the vector of a logarithmic time bins percentage
 *
 * \param max_time_bin (INPUT)
 * \param log_rebin_percent (INPUT) is the rebin percentage
 * \param time_offset (INPUT) is the starting offset time
 * \param debug (INPUT) is a switch that trigger or not the debugging tools
 *
 * \return A vector of the time bin values.
 */
vector<float> generate_log_time_bin_vector(const float max_time_bin,
                                           const int32_t log_rebin_percent,
                                           const int32_t time_offset,
                                           const bool debug)
{
  vector<float> time_bin_vector;
  int32_t i=0;  //use for debugging tool only
  time_bin_vector.push_back(static_cast<int32_t>(0));

  if (debug)
    {
      cout << "\n**Generate logarithmic time bin vector**\n\n";
      cout << "\ttime_bin_vector["<<i<<"]= " << time_bin_vector[i]<<endl;
    }

  float log_rebin = static_cast<float>(log_rebin_percent) / 100;
  float t1;
  float t2= SMALLEST_TIME_BIN;
  
  ++i;
  while (t2 < max_time_bin)
    {
      t1=t2;
      t2 = t1 * (log_rebin + 1.);  //delta_t/t = log_rebin
      time_bin_vector.push_back(static_cast<float>(t2));
      if (debug)
        {
          cout << "\ttime_bin_vector["<<i<<"]= "<<time_bin_vector[i]<<endl;
        }
      ++i;
     }

  return time_bin_vector;
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

      ValueArg<float> maxtimebin("M", "max_time_stamp", 
                                      "Maximum value of time stamp",
                                      true, -1, "Max time bin", cmd);

      ValueArg<int32_t> timerebinwidth("l","linear",
                                       "width of rebin linear time bin",
                                       true, -1, "new linear time bin");

      ValueArg<int32_t> timeoffset("", "offset",
                                   "initial offset time (microS)",
                                   false, 0, "time offset (microS)");

      ValueArg<int32_t> logrebinpercent("L","logarithmic",
                                        "delta_t/t percentage",
                                        true, -1, 
                                        "logarithmic rebinning percentage"); 

      cmd.xorAdd(timerebinwidth, logrebinpercent);
      
      UnlabeledMultiArg<string> event_file_vector("event_file",
                                                  "Name of the event file",
                                                  "filename", cmd);
      // Parse the command-line
      cmd.parse(argc, argv);

      // Create string vector of all input file names
      vector<string> input_file_vector = event_file_vector.getValue();

      bool debug = debugSwitch.getValue();
      if (debug)
        {
          // Table of contents of debug tool
          cout << "************* TABLE OF CONTENTS ******************\n";
          cout << "|\t - In parse_input_file_name                  |\n";
          cout << "|\t - In produce_output_file_name               |\n";
          cout << "|\t - Before swapping the data [if swap_input]  |\n";
          cout << "|\t - After swapping the data [if swap_input]   |\n";
          cout << "|\t - 10 first values [if no swap_input]        |\n";
          cout << "|\t - Generate linear time bin vector           |\n";
          cout << "|\t - In generate_histo                         |\n";
          cout << "*************************************************\n\n";
        }

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
          
          // now file_size is the number of element in the file
          file_size = file_size / sizeof(uint32_t);
          
          float max_time_bin = maxtimebin.getValue();
          int32_t time_rebin_width;
          int32_t log_rebin_percent;
          int32_t time_offset = timeoffset.getValue();
          vector<float> time_bin_vector;

          if (timerebinwidth.isSet())  //if we selected a linear rebinning
            {
              time_rebin_width = timerebinwidth.getValue();
              time_bin_vector=generate_linear_time_bin_vector(max_time_bin,
                                                              time_rebin_width,
                                                              time_offset,
                                                              debug);
            }
          else if (logrebinpercent.isSet()) //if we selected a log rebinning
            {
              log_rebin_percent = logrebinpercent.getValue();
              time_bin_vector = generate_log_time_bin_vector(max_time_bin,
                                                             log_rebin_percent,
                                                             time_offset,
                                                             debug);
            }
          else  
            {
              cerr << "#1: Rebin parameter not supported\n";
              cerr << "#2: If you reach this, see Steve Miller for your price";
            }

          int32_t pixel_number = pixelnumber.getValue();

          //This is the new number of time bins in the histo file
          int32_t new_Nt = time_bin_vector.size();

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
                         time_bin_vector,
                         max_time_bin,
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


                        
