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


int32_t binarySearch(const vector<int32_t> sortedVector, 
                    const int32_t key)
{
  size_t sortedVector_size = sortedVector.size();
  size_t first = 0;
  size_t last = sortedVector_size;
  int32_t result; //-1,0,1

  //check first if the value is out of range
  if (key > sortedVector[sortedVector_size-1] ||
      key < sortedVector[0])
    {
      return -1;
    }

  size_t mid;
  while (first < last-1)
    {
      mid = (first + last) / 2;
      result = compare(sortedVector, key, mid);

      switch (result)
        {
        case -1: last=mid;
          break;
        case 1: first=mid;
          break;
        case 0: return(mid);
        }
    }
  return (first);
}

int32_t compare(const vector<int32_t> sortedVector,
                const int32_t key,
                const size_t index)
{
  int32_t answer;
  if (key < sortedVector[index])
    {
      answer = -1;
    }
  else if (key > sortedVector[index])
    {
      answer = 1;
    }
  else
    {
      answer = 0;
    }
  return answer;
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
                    const int32_t pixelnumber,
                    const int32_t * binary_array,
                    uint32_t * histo_array,
                    const size_t histo_array_size,
                    const vector<int32_t> time_bin_vector,
                    const float max_time_bin,
                    const int32_t time_offset,
                    const bool debug)
{
  int32_t pixelid;
  int32_t time_bin;
  int32_t time_stamp;

  int32_t time_offset_100ns = time_offset * 10;
  int32_t max_time_bin_100ns = static_cast<int>(max_time_bin) * 10;

  //initialize histo array
  initialize_array(histo_array,
                   histo_array_size);

  if (debug)
    {
      cout << "\n\n**In generate_histo**\n\n";
      cout << "\tarray_size= " << array_size << endl;
      cout << "\tnew_Nt= " << new_Nt << endl;
      cout << "\tmax_time_bin(microS)= " << max_time_bin << endl;
      cout << "\tmax_time_bin_100ns= " << max_time_bin_100ns << endl;
      cout << "\ttime_offset(microS)= " << time_offset << endl;
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
          pixelid > pixelnumber ||
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


vector<int32_t> generate_linear_time_bin_vector(const int32_t max_time_bin,
                                                const int32_t time_rebin_width,
                                                const int32_t time_offset,
                                                const string tof_info_filename,
                                                const bool debug)
{
  vector<int32_t> time_bin_vector;
  int32_t i=0;  //use for debugging tool only

  //to go from microS to x100ns
  int32_t max_time_bin_100ns = max_time_bin * 10;
  int32_t time_rebin_width_100ns = time_rebin_width * 10;
  int32_t time_offset_100ns = time_offset * 10;

  if (debug)
    {
      cout << "\n**Generate linear time bin vector**\n\n";
      cout << "\ttime_offset(microS)= " << time_offset<<endl;
      cout << "\ttime_offset(x100ns)= " << time_offset_100ns<<endl;
      cout << "\tmax_time_bin(microS)= " << max_time_bin<<endl;
      cout << "\ttime_rebin_width(microS)= " << time_rebin_width << endl;
      cout << "\tmax_time_bin(x100ns)= " << max_time_bin_100ns << endl;
      cout << "\ttime_rebin_width(x100ns)= " << time_rebin_width_100ns <<endl;
      cout << endl;
    } 

  for (size_t t_bin=time_offset_100ns; 
       t_bin<=max_time_bin_100ns; 
       t_bin+=time_rebin_width_100ns)
    {
      time_bin_vector.push_back(static_cast<int32_t>(t_bin));
      if (debug)
        {
          cout << "\ttime_bin_vector["<<i<<"]= "<<time_bin_vector[i]<<endl;
        }
      ++i;
    }
  
  //check if last time_bin is equal to max_time_bin
  if (time_bin_vector[i-1] < max_time_bin_100ns)
    {
      time_bin_vector.push_back(static_cast<int32_t>(max_time_bin_100ns));
        if (debug)
        {
          cout << "\ttime_bin_vector["<<i<<"]= "<<time_bin_vector[i]<<endl;
        }
    }
  
  size_t time_bin_vector_size = i;
  cout << "time_bin_vector_size= " << time_bin_vector_size << endl; //remove_me
  
  //reconvert axis in microS
  int32_t * time_bin_array = new int32_t [ time_bin_vector_size];
  for (size_t i=0 ; i<time_bin_vector_size ; ++i)
    {
      time_bin_array[i] = time_bin_vector[i]/10;
    }

  //write time_bin_vector into tof_info_filename
  ofstream tof_info_file(tof_info_filename.c_str(),
                         ios::binary);
  tof_info_file.write(reinterpret_cast<char*>(time_bin_array),
                EventHisto::SIZEOF_INT32_T*time_bin_vector_size);
  tof_info_file.close();

  return time_bin_vector;
}


vector<int32_t> generate_log_time_bin_vector(const int32_t max_time_bin,
                                             const int32_t log_rebin_percent,
                                             const int32_t time_offset,
                                             const string tof_info_filename,
                                             const bool debug)
{
  vector<int32_t> time_bin_vector;
  int32_t i=0;  //use for debugging tool only

  //to go from microS to x100ns
  int32_t time_offset_100ns = time_offset * 10;

  time_bin_vector.push_back(static_cast<int32_t>(time_offset_100ns));

  if (debug)
    {
      cout << "\n**Generate logarithmic time bin vector**\n\n";
      cout << "\ttime_bin_vector["<<i<<"]= " << time_bin_vector[i]<<endl;
    }

  float log_rebin = static_cast<float>(log_rebin_percent) / 100;
  float t1;
  float t2= EventHisto::SMALLEST_TIME_BIN + time_offset;
  
  ++i;
  while (t2 < max_time_bin)
    {
      t1 = t2;
      t2 = t1 * (log_rebin + 1.);  //delta_t/t = log_rebin
      time_bin_vector.push_back(static_cast<int32_t>(t2));
      if (debug)
        {
          cout << "\ttime_bin_vector["<<i<<"]= "<<time_bin_vector[i]<<endl;
        }
      ++i;
     }

  return time_bin_vector;
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

      ValueArg<int32_t> maxtimebin("M", "max_time_bin", 
                                      "Maximum value of time stamp",
                                      true, -1, "Max time bin", cmd);

      ValueArg<int32_t> timerebinwidth("l","linear",
                                       "width of rebin linear time bin",
                                       true, -1, "new linear time bin");

      ValueArg<int32_t> timeoffset("", "time_offset",
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

      const bool debug = debugSwitch.getValue();

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
                                                   altoutpath.getValue(),
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
                                                        swapiSwitch.getValue(),
                                                        debug,
                                                        binary_array);

          // now file_size is the number of element in the file

          size_t array_size = file_size / EventHisto::SIZEOF_UINT32_T;

          int32_t max_time_bin = maxtimebin.getValue();
          int32_t time_rebin_width;
          int32_t log_rebin_percent;
          int32_t time_offset = timeoffset.getValue();
          vector<int32_t> time_bin_vector;

          if (timerebinwidth.isSet())  //linear rebinning
            {
              time_rebin_width = timerebinwidth.getValue();
              time_bin_vector=generate_linear_time_bin_vector(max_time_bin,
                                                            time_rebin_width,
                                                            time_offset,
                                                            tof_info_filename,
                                                            debug);
            }
          else if (logrebinpercent.isSet()) //log rebinning
            {
              log_rebin_percent = logrebinpercent.getValue();
              time_bin_vector = generate_log_time_bin_vector(max_time_bin,
                                                             log_rebin_percent,
                                                             time_offset,
                                                             tof_info_filename,
                                                             debug);
            }
          else  
            {
              cerr << "#1: Rebin parameter not supported\n";
              cerr << "#2: If you reach this, see Steve Miller for your award";
              exit(-1);
            }


          int32_t pixel_number = pixelnumber.getValue();

          //This is the new number of time bins in the histo file
          size_t new_Nt = time_bin_vector.size()-1;

          size_t histo_array_size = new_Nt * pixel_number;
          uint32_t * histo_array = new uint32_t [histo_array_size];
          
          //generate histo binary data array
          generate_histo(array_size,
                         new_Nt,
                         pixelnumber.getValue(),
                         binary_array,
                         histo_array,
                         histo_array_size,
                         time_bin_vector,
                         max_time_bin,
                         time_offset,
                         debug);
          
          // free memory allocated to binary_array
          delete binary_array;

          // swap endian of output array (histo_array)
          if(swapoSwitch.getValue())
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

