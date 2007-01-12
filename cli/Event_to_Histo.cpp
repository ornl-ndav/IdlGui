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

const size_t MAX_BLOCK_SIZE = 2048;



int32_t binarySearch(const vector<int32_t> &sortedVector, 
                     const int32_t value, const size_t vector_size)
{
  //check first if the value is out of range
  if (value > sortedVector[vector_size - 1] ||
      value < sortedVector[0])
    {
      return -1;
    }

  size_t first = 0;
  size_t last = vector_size - 1;
  size_t mid = 0;

  while (first <= last)
    {
      mid = (first + last) / 2;
      // search first half of current subvector
      if (value < sortedVector[mid]) 
        {
          last = mid - 1;
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


template <typename NumT>
void write_data_block(ofstream &outfile, 
                      NumT *data, 
                      size_t offset, 
                      size_t num_ele, 
                      size_t sizeof_NumT)
{
  outfile.write(reinterpret_cast<char *>(data + offset),sizeof_NumT * num_ele);
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
                    const bool debug,
                    const bool verbose)
{
  int32_t pixelid;
  int32_t time_bin;
  int32_t time_stamp;
  int32_t processing_percent = 0;
  
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
      cout << "\t\t#     : index number" << endl;
      cout << "------\t\t";
      cout << "Pid   : PixelID" << endl;
      cout << "\t\t    t_ms  : time in micro seconds" << endl;
      cout << "\t\t    tbin: time_bin" << endl << endl;
    }

  //loop over entire binary file data (from 0 to file_size/2 because we use
  //the variable 2*i into the for loop. Like this, the all file is covered.
  size_t time_bin_vector_size = time_bin_vector.size();
  for (size_t i=0 ; i<array_size/2; i++) 
  {
    if (verbose && !debug)
      {
        processing_percent = (2*i*100/array_size);
        cout << "\r" << processing_percent << "%";
      }
    
      pixelid = binary_array[2 * i + 1];
      time_stamp = binary_array[2 * i];
      time_bin = binarySearch(time_bin_vector,time_stamp,time_bin_vector_size);

      if (debug)
        {
          cout << "#" << i << "\t";
          cout << "Pid= " << pixelid << "\t";
          cout << "t_ms= " << time_stamp <<"\t";
          cout << "tstamp_value= ";
          cout << floor(time_bin_vector[time_bin]);
          cout << "\ttbin_position= " << time_bin;
        }

      //remove data that are oustide the scope of range
      if (pixelid < 0 ||                             
          pixelid >= pixel_number ||
          time_stamp < time_offset_100ns ||
          time_stamp > max_time_bin_100ns)
        {
          if (debug)
            {
              cout << "......OUT OF RANGE" << endl;
            }
          continue;
        }
      else
        {
          if (debug)
            {
              cout << "......OK" << endl;
            }
          //record data that is inside the scope of range
          histo_array[time_bin + pixelid * new_Nt] += 1;
        }
  }
  if (verbose && !debug)
    {
      cout << "\r    generate_histo.done\n";
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

      SwitchArg verbose_cmd("", "verbose", "Gives processing information", 
                            false, cmd);

      SwitchArg swap_i_cmd ("", "swap_input", 
                            "Flag for swapping data of input file",
                            false, cmd);
      
      SwitchArg swap_o_cmd ("", "swap_output",
                            "Flag for swapping data of output file",
                             false, cmd);

      SwitchArg das_log_method_cmd("", "das", 
                                   "Use DAS logarithmic rebinning algorithm",
                                   false, cmd);

      ValueArg<int32_t> pixel_number_cmd ("p", "number_of_pixels",
                                          "Number of pixels for this run",
                                          true, -1, "pixel number", cmd);

      ValueArg<float> max_time_bin_cmd("M", "max_time_bin", 
                                         "Maximum value of time stamp",
                                         true, -1, "Max time bin", cmd);

      ValueArg<float> time_rebin_width_cmd("l","linear",
                                             "width of rebin linear time bin",
                                             true, -1, "new linear time bin");

      ValueArg<float> time_offset_cmd("", "time_offset",
                                        "initial offset time (microS)",
                                        false, 0, "time offset (microS)",cmd);

      ValueArg<float> log_rebin_coeff_cmd("L","logarithmic",
                                          "delta_t/t coefficient",
                                          true, 1, 
                                "logarithmic rebinning coefficient."); 

      cmd.xorAdd(time_rebin_width_cmd, log_rebin_coeff_cmd);

      UnlabeledMultiArg<string> event_file_vector_cmd("event_file",
                                                      "Name of the event file",
                                                      "filename", cmd);
      // Parse the command-line
      cmd.parse(argc, argv);

      // Create string vector of all input file names
      vector<string> input_file_vector = event_file_vector_cmd.getValue();

      const bool debug = debug_cmd.getValue();
      const bool verbose = verbose_cmd.getValue();

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
      size_t input_file_vector_size=input_file_vector.size();
      for (size_t i=0 ; i<input_file_vector_size ; ++i)
        {
          string input_filename;
          string output_filename("");
          string tof_info_filename("");
          string path; 
          string input_file = input_file_vector[i];

          if (verbose || debug)
            {
              cout << "**** file name: " << input_file << " ****\n";
              cout << "--> path_input_output_file_names.";  //1st
            }
          
          EventHisto::path_input_output_file_names(input_file,
                                                   input_filename,
                                                   path,
                                                   alt_out_path_cmd.getValue(),
                                                   output_filename,
                                                   tof_info_filename,
                                                   debug,
                                                   verbose);

          if (verbose || !debug) { cout << "done\n"; }

          // read input file and populate the binary array 
          size_t file_size;
          int32_t * binary_array;
          
          if (verbose || debug)
            {
              cout << "--> read_event_file_and_populate_binary_array.";  //1st
            }
          
          file_size = 
            EventHisto::read_event_file_and_populate_binary_array(input_file,
                                                        input_filename,
                                                        n_disp,
                                                        swap_i_cmd.getValue(),
                                                        debug,
                                                        verbose,
                                                        binary_array);

          if (verbose && !debug)
            {
              cout << "done\n";
            }

          // now file_size is the number of element in the file
          size_t array_size = file_size / EventHisto::SIZEOF_UINT32_T;

          int32_t max_time_bin_100ns
            = static_cast<int32_t>(max_time_bin_cmd.getValue() * 10.);
          int32_t time_rebin_width_100ns;

          
          //check that the time_offset in 100ns scale is at least 1
          int32_t time_offset_100ns
            = static_cast<int32_t>(time_offset_cmd.getValue() * 10.);
          if (time_offset_100ns !=0 && 
              time_offset_100ns < EventHisto::SMALLEST_TIME_BIN_100NS)
                {
                  time_offset_100ns = EventHisto::SMALLEST_TIME_BIN_100NS;
                }
             
          vector<int32_t> time_bin_vector;

          if (time_rebin_width_cmd.isSet())  //linear rebinning
            {
              time_rebin_width_100ns
                = static_cast<int32_t>(time_rebin_width_cmd.getValue() * 10.);
              
              if (verbose || debug)
                {
                  cout << "--> generate_linear_time_bin_vector.";  //1st
                }
              time_bin_vector=generate_linear_time_bin_vector(
                                                        max_time_bin_100ns,
                                                        time_rebin_width_100ns,
                                                        time_offset_100ns,
                                                        debug,
                                                        verbose);
              if (verbose && !debug)
                {
                  cout << "done\n";
                }

            }
          else if (log_rebin_coeff_cmd.isSet()) //log rebinning
            {
              float log_rebin_coeff
                = static_cast<float>(log_rebin_coeff_cmd.getValue());
              
              if (das_log_method_cmd.getValue())
                {
                  //DAS way
                  if (verbose || debug)
                    {
                      cout << "--> generate_das_log_time_bin_vector.";  //1st
                    }
                  
                  time_bin_vector = 
                    generate_das_log_time_bin_vector(
                                                     max_time_bin_100ns,
                                                     log_rebin_coeff,
                                                     time_offset_100ns,
                                                     debug,
                                                     verbose);
                }
              else
                {
                  //ASG way
                  if (verbose || debug)
                    {
                      cout << "--> generate_log_time_bin_vector.";  //1st
                    }
                  
                  time_bin_vector = 
                    generate_log_time_bin_vector(
                                                 max_time_bin_100ns,
                                                 log_rebin_coeff,
                                                 time_offset_100ns,
                                                 debug,
                                                 verbose);
                }
              
              if (verbose && !debug)
                {
                  cout << "done\n";
                }
            }
          else  
            {
              cerr << "#1: Rebin parameter not supported\n";
              cerr << "#2: If you reach this, see Steve Miller for your award";
              exit(-1);
            }

          if (debug || verbose)
            {
              cout << "--> output_time_bin_vector.";  //1st
            }
          //output the time bin vector data
          output_time_bin_vector(time_bin_vector,
                                 tof_info_filename,
                                 debug,
                                 verbose);

          if (verbose && !debug)
            {
              cout << "done\n";
            }

          int32_t pixel_number = pixel_number_cmd.getValue();

          //this is the new number of time bins in the histo file
          size_t new_Nt = time_bin_vector.size() - 1;

          size_t histo_array_size = new_Nt * pixel_number;
          uint32_t * histo_array = new uint32_t [histo_array_size];
          
          if (verbose || debug)
            {
              cout << "--> generate_histo...(processing)...\n"; 
            }

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
                         debug,
                         verbose);

          // free memory allocated to binary_array
          delete binary_array;

          // swap endian of output array (histo_array)
          if(swap_o_cmd.getValue())
            {
              if (verbose || debug)
                {
                  cout << "--> swap_endian.";  //1st
                }
              EventHisto::swap_endian(histo_array_size, histo_array);
              if (verbose || debug)
                {
                  cout << "done\n";
                }
            }
          
          if (debug || verbose)
            {
              cout << "--> write_data_block.";  //1st
            }

          // write new histogram file
          ofstream histo_file(output_filename.c_str(),
                                   ios::binary);
          size_t block_size=MAX_BLOCK_SIZE;
          if(histo_array_size<block_size){
            block_size=histo_array_size;
          }
          size_t offset=0;
          while(offset<histo_array_size)
            {
              write_data_block(histo_file,
                               histo_array,
                               offset,block_size,
                               EventHisto::SIZEOF_UINT32_T);
              offset+=block_size;
              if(offset+block_size>histo_array_size)
                {
                  block_size=histo_array_size-offset;
                }
            }

          if (verbose || debug)
            {
              cout << "done\n"; 
            }

          histo_file.close();
          
          // free memory allocated to histo_array
          delete histo_array;

          if (verbose || debug)
            {
              cout << "**** file name: " << input_file << " ****(end of processing)\n";
              
            }
        }
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}

