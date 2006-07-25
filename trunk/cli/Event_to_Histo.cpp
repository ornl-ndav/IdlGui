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
using namespace BinVectorUtils;

int32_t binarySearch(const vector<int32_t> sortedVector, 
                    const int32_t value)
{
  size_t vector_size = sortedVector.size();

  //check first if the value is out of range
  if (value > sortedVector[vector_size-1] ||
      value < sortedVector[0])
    {
      return -1;
    }

  size_t first = 0;
  size_t last = vector_size-1;
  size_t mid = 0;

  while (first <= last)
    {
      mid = (first + last) / 2;
      // search first half of current subvector
      if (value < sortedVector[mid]) 
        {
          last = mid -1;
        }
      // search second half of current subvector
      else if (value > sortedVector[mid])
        {
          first = mid + 1;
        }
      // we got it
      else
        {
          // value is on last boundary
          if (value == sortedVector[vector_size-1])
            {
              return (mid - 1);
            }
          // value is in earlier bin boundary
          else
            {
              return (mid);
            }
        }
    }
  
  // the indices crossed, so the value is not in the list
  // but we can determine which bin it is in.
  return last;
}


void initialize_array(uint32_t * histo_array, 
                      const size_t size)
{
  for (size_t i=0 ; i<size ; ++i)
    {
      histo_array[i]=0;
     }
  
  return;   
}


void generate_histo(const size_t array_size,
                    const int32_t new_Nt,
                    const int32_t pixel_number,
                    const int32_t * binary_array,
                    uint32_t * histo_array,
                    const size_t histo_array_size,
                    const vector<int32_t> time_bin_vector,
                    const int32_t max_time_bin_100ns,
                    const int32_t time_offset_100ns,
                    const bool debug)
{
  int32_t pixelid;
  int32_t time_bin;
  int32_t time_stamp;

  //initialize histo array
  initialize_array(histo_array,
                   histo_array_size);

  if (debug)
    {
      cout << "\n\n**In generate_histo**\n\n";
      cout << "\tarray_size= " << array_size << endl;
      cout << "\tnew_Nt= " << new_Nt << endl;
      cout << "\tmax_time_bin_100ns= " << max_time_bin_100ns << endl;
      cout << "\ttime_offset_100ns= " << time_offset_100ns << endl;
      cout << "\nLegend:";
      cout << "\t\t#     : index number\n";
      cout << "------\t\t";
      cout << "Pid   : PixelID\n";
      cout << "\t\t    t_ms  : time in micro seconds\n";
      cout << "\t\t    tbin: time_bin\n\n";
    }

  //loop over entire binary file data (from 0 to file_size/2 because we use
  //the variable 2*i into the for loop. Like this, the all file is covered.
  for (size_t i=0 ; i<array_size/2; i++) 
  {
    cout << " " << i;
      pixelid = binary_array[2*i+1];
      time_stamp = binary_array[2*i];
      time_bin = binarySearch(time_bin_vector,time_stamp);

      if (debug)
        {
          cout << "#" << i << "\t";
          cout << "Pid= " << pixelid <<"\t";
          cout << "t_ms= " << time_stamp <<"\t";
          cout << "tstamp_value= ";
          cout << floor(time_bin_vector[time_bin]);
          cout << "\ttbin_position= " << time_bin;
        }

      //remove data that are oustide the scope of range
      if (pixelid < 0 ||                             
          pixelid > pixel_number ||
          time_stamp < time_offset_100ns ||
          time_stamp > max_time_bin_100ns)
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
          histo_array[time_bin+pixelid*new_Nt]+=1;
        }
  }
  return;
}

int32_t main(int32_t argc, char *argv[])
{
  try
    {
      // Setup the command-line parser object
      CmdLine cmd("Command line description message", ' ', 
                  EventHisto::VERSION_TAG);
      
      // Add command-line options
      ValueArg<size_t> n_disp_cmd("n","data_displayed",
                                  "number of element to display",
                                  false, 10, "element to display", cmd);

      ValueArg<string> alt_out_path_cmd("a", "alternate_output", 
                                        "Alternate path for output file",
                                        false, "", "path", cmd);
      
      SwitchArg debug_cmd("d", "debug", "Flag for debugging program",
                          false, cmd);

      SwitchArg swap_i_cmd ("", "swap_input", 
                            "Flag for swapping data of input file",
                            false, cmd);
      
      SwitchArg swap_o_cmd ("", "swap_output",
                            "Flag for swapping data of output file",
                             false, cmd);

      ValueArg<int32_t> pixel_number_cmd ("p", "number_of_pixels",
                                          "Number of pixels for this run",
                                          true, -1, "pixel number", cmd);

      ValueArg<int32_t> max_time_bin_cmd("M", "max_time_bin", 
                                         "Maximum value of time stamp",
                                         true, -1, "Max time bin", cmd);

      ValueArg<int32_t> time_rebin_width_cmd("l","linear",
                                             "width of rebin linear time bin",
                                             true, -1, "new linear time bin");

      ValueArg<int32_t> time_offset_cmd("", "time_offset",
                                        "initial offset time (microS)",
                                        false, 0, "time offset (microS)",cmd);

      ValueArg<float> log_rebin_coeff_cmd("L","logarithmic",
                                          "delta_t/t coefficient (>=0.05)",
                                          true, 1, 
                                "logarithmic rebinning coefficient (>=0.05)"); 

      cmd.xorAdd(time_rebin_width_cmd, log_rebin_coeff_cmd);
      
      UnlabeledMultiArg<string> event_file_vector_cmd("event_file",
                                                      "Name of the event file",
                                                      "filename", cmd);
      // Parse the command-line
      cmd.parse(argc, argv);

      // Create string vector of all input file names
      vector<string> input_file_vector = event_file_vector_cmd.getValue();

      const bool debug = debug_cmd.getValue();

      size_t n_disp = n_disp_cmd.getValue();

      if (debug)
        {
          // Table of contents of debug tool
          cout << "************* TABLE OF CONTENTS *******************\n";
          cout << "|\t - In parse_input_file_name                     \n";
          cout << "|\t - In produce_output_file_name                  \n";
          cout << "|\t - In produce_tof_info_file_name                \n";
          cout << "|\t - first values and last value of binary_array  \n";
          cout << "|\t - After swapping the data                      \n";
          cout << "|\t - Generate linear time bin vector              \n";
          cout << "|\t - In generate_histo                            \n";
          cout << "*************************************************\n\n";
        }

      // loop over all input files names
      for (size_t i=0 ; i<input_file_vector.size() ; ++i)
        {
          string input_filename;
          string output_filename("");
          string tof_info_filename("");
          string path; 
          string input_file = input_file_vector[i];

          
          EventHisto::path_input_output_file_names(input_file,
                                                   input_filename,
                                                   path,
                                                   alt_out_path_cmd.getValue(),
                                                   output_filename,
                                                   tof_info_filename,
                                                   debug);

          // read input file and populate the binary array 
          size_t file_size;
          int32_t * binary_array;
          
          file_size = 
            EventHisto::read_event_file_and_populate_binary_array(input_file,
                                                        input_filename,
                                                        n_disp,
                                                        swap_i_cmd.getValue(),
                                                        debug,
                                                        binary_array);

          // now file_size is the number of element in the file

          size_t array_size = file_size / EventHisto::SIZEOF_UINT32_T;

          int32_t max_time_bin_100ns = max_time_bin_cmd.getValue() * 10;
          int32_t time_rebin_width_100ns;
          float log_rebin_coeff_100ns;
          
          //check that the time_offset in 100ns scale is at least 1
          int32_t time_offset_100ns = time_offset_cmd.getValue() * 10;
          if (time_offset_100ns !=0 && 
              time_offset_100ns < EventHisto::SMALLEST_TIME_BIN_100NS)
                {
                  time_offset_100ns = EventHisto::SMALLEST_TIME_BIN_100NS;
                }
             
          vector<int32_t> time_bin_vector;

          if (time_rebin_width_cmd.isSet())  //linear rebinning
            {
              time_rebin_width_100ns = time_rebin_width_cmd.getValue() * 10;
              time_bin_vector=generate_linear_time_bin_vector(
                                                        max_time_bin_100ns,
                                                        time_rebin_width_100ns,
                                                        time_offset_100ns,
                                                        debug);
            }
          else if (log_rebin_coeff_cmd.isSet()) //log rebinning
            {
              log_rebin_coeff_100ns = log_rebin_coeff_cmd.getValue() * 10;
              //check if log_rebin_coeff_100ns is greater or equal to 0.5
              //otherwise forces a value of 1
              if (log_rebin_coeff_100ns < 0.5)
                {
                  log_rebin_coeff_100ns = 0.5;
                }
              time_bin_vector = generate_log_time_bin_vector(
                                                        max_time_bin_100ns,
                                                        log_rebin_coeff_100ns,
                                                        time_offset_100ns,
                                                        debug);
            }
          else  
            {
              cerr << "#1: Rebin parameter not supported\n";
              cerr << "#2: If you reach this, see Steve Miller for your award";
              exit(-1);
            }

          //output the time bin vector data
          output_time_bin_vector(time_bin_vector,
                                 tof_info_filename,
                                 debug);

          int32_t pixel_number = pixel_number_cmd.getValue();

          //this is the new number of time bins in the histo file
          size_t new_Nt = time_bin_vector.size()-1;

          size_t histo_array_size = new_Nt * pixel_number;
          uint32_t * histo_array = new uint32_t [histo_array_size];
          
          //generate histo binary data array
          generate_histo(array_size,
                         new_Nt,
                         pixel_number,
                         binary_array,
                         histo_array,
                         histo_array_size,
                         time_bin_vector,
                         max_time_bin_100ns,
                         time_offset_100ns,
                         debug);
          
          // free memory allocated to binary_array
          delete binary_array;

          // swap endian of output array (histo_array)
          if(swap_o_cmd.getValue())
            {
              EventHisto::swap_endian(histo_array_size, histo_array);
            }
          
          // write new histogram file
          ofstream histo_file(output_filename.c_str(),
                                   ios::binary);
          histo_file.write(reinterpret_cast<char*>(histo_array),
                           EventHisto::SIZEOF_UINT32_T*histo_array_size);
          histo_file.close();
          
          // free memory allocated to histo_array
          delete histo_array;
        }
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}

