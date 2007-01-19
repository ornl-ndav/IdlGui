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
 * \file Bin_Vector_Utils.cpp
 */

#include "bin_vector_utils.hpp"

using namespace std;

namespace BinVectorUtils
{
  vector<int32_t> 
  generate_linear_time_bin_vector(const int32_t max_time_bin_100ns,
                                  const int32_t time_rebin_width_100ns,
                                  const int32_t time_offset_100ns,
                                  const bool debug,
                                  const bool verbose)
  {
    vector<int32_t> time_bin_vector;
    int32_t i=0;  //use for debugging tool only
    
    if (verbose && !debug) 
      {
        cout << ".";
      }  //2nd

    if (debug)
      {
        cout << "\n**Generate linear time bin vector**\n\n";
        cout << "\ttime_offset(x100ns)= " << time_offset_100ns<<endl;
        cout << "\tmax_time_bin(x100ns)= " << max_time_bin_100ns << endl;
        cout << "\ttime_rebin_width(x100ns)= " << time_rebin_width_100ns;
        cout << "\n\n";
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
    
    if (verbose && !debug) 
      {
        cout << ".";
      }  //3rd
    
    //check if last time_bin is equal to max_time_bin
    if (time_bin_vector[i-1] < max_time_bin_100ns)
      {
        time_bin_vector.push_back(static_cast<int32_t>(max_time_bin_100ns));
        if (debug)
          {
            cout << "\ttime_bin_vector["<<i<<"]= "<<time_bin_vector[i]<<endl;
          }
      }
    
    if (verbose && !debug) 
      {
        cout << "done";
      }  //done
    
    return time_bin_vector;
  }
  
  
  vector<int32_t> 
  generate_log_time_bin_vector(const int32_t max_time_bin_100ns,
                               const float log_rebin_coeff,
                               const int32_t time_offset_100ns,
                               const bool debug,
                               const bool verbose)
  {
    vector<int32_t> time_bin_vector;

    if (verbose && !debug) 
      {
        cout << ".";
      }  //2nd

    float minimum_time_bin_100ns_local = EventHisto::SMALLEST_TIME_BIN;

    //first value of time_bin_vector is time_offset_100ns if time_offset_100ns is greater
    if (minimum_time_bin_100ns_local < time_offset_100ns)
      {
        time_bin_vector.push_back(static_cast<int32_t>(time_offset_100ns));
      }
    else
      {
        time_bin_vector.push_back(static_cast<int32_t>(minimum_time_bin_100ns_local));
      }

    if (verbose && !debug) 
      {
        cout << ".";
      }  //3rd

    if (debug)
      {
        cout << "\n**Generate logarithmic time bin vector**\n\n";
        cout << "\t log_rebin_coeff= " << log_rebin_coeff << "\n";
        cout << "\t max_time_bin(100ns)= " << max_time_bin_100ns << "\n";
        cout << "\t time_offset(100ns)= " << time_offset_100ns << "\n";
        cout << "\t minimum_time_bin(100ns)= " << minimum_time_bin_100ns_local << "\n\n";
        cout << "\ttime_bin_vector[0]= " << time_bin_vector[0] << "\n";
      }
    
    int32_t t1;
    //    float t2= EventHisto::SMALLEST_TIME_BIN + time_offset_100ns;
    int32_t t2 = time_bin_vector[0];

    while (t2 < max_time_bin_100ns)
      {
        t1 = t2;
        //delta_t/t=log_rebin_coeff
        //0.5 argument is to make sure the correct int is determined at cast
        t2 = static_cast<int32_t>((static_cast<float>(t1) * 
                                   (log_rebin_coeff + 
                                    static_cast<float>(1.)) + 
                                   static_cast<float>(0.5)));
        if (t2 > max_time_bin_100ns)
          {
            t2 = max_time_bin_100ns;
          }
        time_bin_vector.push_back(static_cast<int32_t>(t2));
        if (debug)
          {
            cout << "\ttime_bin_vector["<<time_bin_vector.size()-1 << \
              "]= "<<time_bin_vector[time_bin_vector.size()-1]<<endl;
          }
      }
    
    if (verbose && !debug) 
      {
        cout << "done";
      }  //done

    return time_bin_vector;
  }
  




  vector<int32_t> 
  generate_das_log_time_bin_vector(const int32_t max_time_bin_100ns,
                                   const float log_rebin_coeff,
                                   const int32_t time_offset_100ns,
                                   const bool debug,
                                   const bool verbose)
  {
    vector<int32_t> time_bin_vector;
    int32_t i=0;  //use by debugging tool only

    if (verbose && !debug) 
      {
        cout << ".";
      }  //2nd
    
    float minimum_time_bin_100ns_local = EventHisto::SMALLEST_TIME_BIN;

    //first value of time_bin_vector is time_offset_100ns if time_offset_100ns is greater
    if (minimum_time_bin_100ns_local < time_offset_100ns)
      {
        time_bin_vector.push_back(static_cast<int32_t>(time_offset_100ns));
      }
    else
      {
        time_bin_vector.push_back(static_cast<int32_t>(minimum_time_bin_100ns_local));
      }

    if (verbose && !debug) 
      {
        cout << ".";
      }  //3rd

    if (debug)
      {
        cout << "\n**Generate logarithmic time bin vector**\n\n";
        cout << "\t log_rebin_coeff= " << log_rebin_coeff << "\n";
        cout << "\t max_time_bin(100ns)= " << max_time_bin_100ns << "\n";
        cout << "\t time_offset(100ns)= " << time_offset_100ns << "\n";
        cout << "\t minimum_time_bin(100ns)= " << minimum_time_bin_100ns_local << "\n\n";
        cout << "\ttime_bin_vector[0]= " << time_bin_vector[i] << "\n";
      }
    
    float t1;
    float t2 = time_bin_vector[0];
    
    ++i;
    while (t2 < max_time_bin_100ns)
      {
        t1 = t2;
        //delta_t/t=log_rebin_coeff
        t2 = float((t1) *(log_rebin_coeff + 1));
        if (t2 == t1)
          {
            t2=t1+1;
          }
        if (t2 > max_time_bin_100ns)
          {
            t2 = max_time_bin_100ns;
          }
        time_bin_vector.push_back(static_cast<int32_t>(t2));
        if (debug)
          {
            cout << "\ttime_bin_vector["<<i<<"]= "<<time_bin_vector[i]<<endl;
          }
        ++i;
      }
    
    if (verbose && !debug) 
      {
        cout << "done";
      }  //done

    return time_bin_vector;
  }







  void output_time_bin_vector(const vector<int32_t> time_bin_vector,
                              const string tof_info_filename,
                              const bool debug,
                              const bool verbose)
  {
    size_t time_bin_vector_size = time_bin_vector.size();
    
    if (verbose && !debug) 
      {
        cout << ".";
      }  //2nd

    //reconvert axis in microS
    float * time_bin_array = new float [time_bin_vector_size];
    for (size_t i=0 ; i<time_bin_vector_size ; ++i)
      {
        time_bin_array[i] = static_cast<float>(time_bin_vector[i])/10.;
      }
    
    if (verbose && !debug) 
      {
        cout << ".";
      }  //3rd

    //write time_bin_vector into tof_info_filename
    ofstream tof_info_file(tof_info_filename.c_str(),
                           ios::binary);

    if (verbose && !debug) 
      {
        cout << ".";
      }  //4th

    tof_info_file.write(reinterpret_cast<char*>(time_bin_array),
                        sizeof(float)*time_bin_vector_size);

    if (verbose && !debug) 
      {
        cout << ".";
      }  //5th

    tof_info_file.close();
    
    if (verbose && !debug) 
      {
        cout << "done";
      } //done

    return;
  }
  
}
