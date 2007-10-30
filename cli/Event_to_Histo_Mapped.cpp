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
 * \file Event_to_Histo_Mapped.cpp
 */

#include "Event_to_Histo.hpp"
#include "Map_Data.hpp"
#include "utils.hpp"
#include "ctime"  //REMOVE_ME

using namespace std;
using namespace TCLAP;
using namespace BinVectorUtils;

const size_t MAX_BLOCK_SIZE = 2048;

/**
 * \brief This program takes a binary event data file, a mapping file
 *        and creates a mapped binary histogram file.
 *
 * This program takes a neutron binary event data file, a pixel
 * mapping file and creates a mapped neutron binary histogram data
 * file. The number of detector pixels and number of time-of-flight
 * channels must be provided to the program. An alternate path for
 * the create binary data file can be provided. For usage of the
 * program do
 * <code>
 * Event_to_Histo_Mapped -h 
 * </code>
 * or
 * <code>
 * Event_to_Histo_Mapped --help 
 * </code>
 *
 * \param argc
 * \param **argv
 * 
 * \return An integer status number
 */
int32_t main(int32_t argc, char *argv[])
{
  time_t time_start; //REMOVE_ME
  time_start = time(NULL); //REMOVE_ME

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
      
      SwitchArg debug_cmd("d", "debug",
                            "Flag for debugging program",
                            false, cmd);

      SwitchArg verbose_cmd("", "verbose",
                            "Gives processing information", 
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

      ValueArg<int32_t> pixel_number_cmd("p", "number_of_pixels",
                            "Number of detector pixels for this run", 
                            true, -1, "# of pixels", cmd);

      ValueArg<float> max_time_bin_cmd("M", "max_time_bin", 
                            "Maximum value of time stamp",
                            true, -1, "Max time bin", cmd);

      ValueArg<float> time_rebin_width_cmd("l","linear",
                            "width of rebin linear time bin",
                            true, -1, "new linear time bin");

      SwitchArg old_linear_rebin_method_cmd("", "old_linear",
                            "Use old linear histogramming algorithm",
                            false, cmd);

      // set default time offset to 1, not 0...
      // - time_offset_100ns == 0 is for "secret special mode",
      //       where we count all those impossible neutrons with
      //       tofs less than the supposed DAS clock resolution... :-D
      // - time_offset_100ns == 1 will get clamped to SMALLEST_TIME_BIN
      ValueArg<float> time_offset_cmd("", "time_offset",
                            "initial offset time (microS)",
                            false, 1, "time offset (microS)",cmd);

      ValueArg<float> log_rebin_coeff_cmd("L","logarithmic",
                            "delta_t/t coefficient",
                            true, 1, 
                            "logarithmic rebinning coefficient."); 

      cmd.xorAdd(time_rebin_width_cmd, log_rebin_coeff_cmd);

      UnlabeledMultiArg<string> event_file_vector_cmd("event_file",
                            "Name of the event file",
                            "filename", cmd);

      // Add command-line options
      ValueArg<string> mapArg("m", "mapping",
                            "Name of the mapping file", 
                            true, "map.dat", "filename", cmd);

      // Parse the command-line
      cmd.parse(argc, argv);

      // Create string vector of all input file names
      vector<string> input_file_vector =
              event_file_vector_cmd.getValue();

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
        time_t time_read_start; //REMOVE_ME
        time_read_start = time(NULL); //REMOVE_ME

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

        if (verbose || debug) 
        { 
          cout << "done\n"; 
        }

        // read input file and populate the binary array 
        size_t file_size;
        int32_t * binary_array;
        
        if (verbose || debug)
        {
          cout
            << "--> read_event_file_and_populate_binary_array."; //1st
        }
        
        file_size = 
                EventHisto::read_event_file_and_populate_binary_array(
                        input_file,
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

        time_t time_read_end; //REMOVE_ME
        time_read_end = time(NULL); //REMOVE_ME

        printf("%ld seconds to read file, size=%d\n",
          (time_read_end-time_read_start), file_size); //REMOVE_ME

        // now file_size is the number of element in the file
        size_t array_size = file_size / EventHisto::SIZEOF_UINT32_T;

        int32_t max_time_bin_100ns
          = static_cast<int32_t>(max_time_bin_cmd.getValue() * 10.);
        int32_t time_rebin_width_100ns;

        
        //check that the time_offset in 100ns scale is at least 1
        int32_t time_offset_100ns
          = static_cast<int32_t>(time_offset_cmd.getValue() * 10.);
        // round up time offset to smallest time bin (clock resolution)
        // - UNLESS time_offset_100ns is 0, for "secret special mode",
        //       where we count all those impossible neutrons with
        //       tofs less than the supposed DAS clock resolution... :-D
        if (time_offset_100ns != 0 && 
            time_offset_100ns < EventHisto::SMALLEST_TIME_BIN)
        {
           time_offset_100ns = EventHisto::SMALLEST_TIME_BIN;
        }
           
        vector<int32_t> time_bin_vector;

        if (time_rebin_width_cmd.isSet())  //linear rebinning
        {
          time_rebin_width_100ns
            = static_cast<int32_t>(time_rebin_width_cmd.getValue()
              * 10.);
            
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
          float log_rebin_coeff = log_rebin_coeff_cmd.getValue();
          
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
          cerr <<
              "#2: If you reach this, see Steve Miller for your award";
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

        time_t time_bin_end; //REMOVE_ME
        time_bin_end = time(NULL); //REMOVE_ME

        printf("%ld seconds to generate time bins\n",
          (time_bin_end-time_read_end)); //REMOVE_ME

        int32_t pixel_number = pixel_number_cmd.getValue();

        //this is the new number of time bins in the histo file
        size_t new_Nt = time_bin_vector.size() - 1;
        printf( "new_Nt = %d\n", new_Nt );

        size_t histo_array_size = new_Nt * pixel_number;
        uint32_t * histo_array = new uint32_t [histo_array_size];
        
        //generate histo binary data array
        
        if (time_rebin_width_cmd.isSet() &&    //linear rebinning and
            old_linear_rebin_method_cmd.isSet())  //old way
        {
          if (verbose || debug)
          {
            cout <<
              "--> generate_histo - old_way (processing).\n"; //1st
          }
          generate_histo_old_way(array_size,
                  new_Nt,
                  pixel_number,
                  binary_array,
                  histo_array,
                  histo_array_size,
                  max_time_bin_100ns,
                  time_offset_100ns,
                  time_rebin_width_100ns,
                  debug,
                  verbose);
        }

        else
        {
          if (verbose || debug)
          {
            cout
              << "--> generate_histo - binary (processing).\n"; //1st
          }

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
        }

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
        
        time_t time_histo_end; //REMOVE_ME
        time_histo_end = time(NULL); //REMOVE_ME

        printf("%ld seconds to generate histogram\n",
          (time_histo_end-time_bin_end)); //REMOVE_ME

        printf("(effective rate = %lf events per second)\n",
          (double)file_size / (double)(time_histo_end-time_bin_end));
          //REMOVE_ME

        // if (debug || verbose)
        // {
        //   cout << "--> write_data_block.";  //1st
        // }

        // // write new histogram file
        // ofstream histo_file(output_filename.c_str(),
        //                          ios::binary);
        // size_t block_size=MAX_BLOCK_SIZE;
        // if(histo_array_size<block_size){
        //   block_size=histo_array_size;
        // }
        // size_t offset=0;
        // while(offset<histo_array_size)
        // {
        //   write_data_block(histo_file,
        //           histo_array,
        //           offset,block_size,
        //           EventHisto::SIZEOF_UINT32_T);
        //   offset+=block_size;
        //   if(offset+block_size>histo_array_size)
        //   {
        //     block_size=histo_array_size-offset;
        //   }
        // }

        // if (verbose || debug)
        // {
        //   cout << "done\n"; 
        // }

        // if (verbose || debug)
        // {
        //   cout << "--> close histo_file.";  //1st 
        // }
        // histo_file.close();
        // if (verbose || debug)
        // {
        //   cout << "done\n"; 
        // }
        
        // time_t time_write_end; //REMOVE_ME
        // time_write_end = time(NULL); //REMOVE_ME

        // printf("%ld seconds to write histogram file\n",
        //   (time_write_end-time_histo_end)); //REMOVE_ME

        // Create the pixel map
        map<int32_t, int32_t> pixel_map;
        pixel_map = make_pixel_map(mapArg.getValue(),
                pixel_number,
                debug);

        // Create the mapped binary data
        create_mapped_data_incore(histo_array, histo_array_size,
                make_mapped_filename(output_filename.c_str(),
                        alt_out_path_cmd.getValue(),
                        debug),
                new_Nt, pixel_map, 
                debug);
  
        time_t time_map_end; //REMOVE_ME
        time_map_end = time(NULL); //REMOVE_ME

        printf("%ld seconds to map histogram data & write file\n",
          (time_map_end-time_histo_end)); //REMOVE_ME

        // if (verbose || debug)
        // {
        //   cout << "--> free memory of histo_array.";  //1st
        // }

        // // free memory allocated to histo_array
        // delete histo_array;

        // if (verbose || debug)
        // {
        //   cout << "done\n"; 
        // }

        if (verbose || debug)
        {
          cout << "**** file name: " << input_file
            << " ****(end of processing)\n";
        }
     }
  }
  catch (ArgException &e)
  {
    cerr << "Error: " << e.error() << " for arg "
      << e.argId() << endl;
  }

  time_t time_end; //REMOVE_ME
  time_end = time(NULL); //REMOVE_ME

  printf("%ld seconds to process\n",(time_end-time_start)); //REMOVE_ME

  return 0;
}

