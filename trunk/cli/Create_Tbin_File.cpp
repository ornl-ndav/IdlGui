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
 * \file Create_Tbin_File.cpp
 */

#include "Create_Tbin_File.hpp"

using namespace std;
using namespace TCLAP;
using namespace BinVectorUtils;

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

      SwitchArg debug_cmd("d", "debug", "Flag for debugging program",
                          false, cmd);

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

      ValueArg<string> output_file_name_cmd("o","output_file_name",
                                            "Binary output file name",
                                            true, "", "name of output file",
                                            cmd);
      
      cmd.xorAdd(time_rebin_width_cmd, log_rebin_coeff_cmd);
      
      // Parse the command-line
      cmd.parse(argc, argv);

      int32_t max_time_bin_100ns = max_time_bin_cmd.getValue() * 10;

      const bool debug = debug_cmd.getValue();

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
          int32_t time_rebin_width_100ns = time_rebin_width_cmd.getValue()*10;
          time_bin_vector=generate_linear_time_bin_vector(
                                                      max_time_bin_100ns,
                                                      time_rebin_width_100ns,
                                                      time_offset_100ns,
                                                      debug);
        }
      else if (log_rebin_coeff_cmd.isSet()) //log rebinning
        {
          float log_rebin_coeff_100ns = log_rebin_coeff_cmd.getValue()*10;

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
                             output_file_name_cmd.getValue(),
                             debug);
      
    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}
