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
                                  const bool debug)
  {
    vector<int32_t> time_bin_vector;
    int32_t i=0;  //use for debugging tool only
    
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
    
    //check if last time_bin is equal to max_time_bin
    if (time_bin_vector[i-1] < max_time_bin_100ns)
      {
        time_bin_vector.push_back(static_cast<int32_t>(max_time_bin_100ns));
        if (debug)
          {
            cout << "\ttime_bin_vector["<<i<<"]= "<<time_bin_vector[i]<<endl;
          }
      }
    
    
    return time_bin_vector;
  }
  
  
  vector<int32_t> 
  generate_log_time_bin_vector(const int32_t max_time_bin_100ns,
                               const float log_rebin_coeff_100ns,
                               const int32_t time_offset_100ns,
                               const bool debug)
  {
    vector<int32_t> time_bin_vector;
    int32_t i=0;  //use for debugging tool only
    
    time_bin_vector.push_back(static_cast<int32_t>(time_offset_100ns));
    
    if (debug)
      {
        cout << "\n**Generate logarithmic time bin vector**\n\n";
        cout << "\t log_rebin_coeff(100ns)= " << log_rebin_coeff_100ns << endl;
        cout << "\t max_time_bin(100ns)= " << max_time_bin_100ns << endl;
        cout << "\t time_offset(100ns)= " << time_offset_100ns << "\n\n";
        cout << "\ttime_bin_vector[0]= " << time_bin_vector[i]<<endl;
      }
    
    float t1;
    float t2= EventHisto::SMALLEST_TIME_BIN_100NS + time_offset_100ns;
    
    ++i;
    while (t2 < max_time_bin_100ns)
      {
        t1 = t2;
        //delta_t/t=log_rebin_coeff_100ns
        t2 = t1 * (log_rebin_coeff_100ns + 1.);
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
    
    return time_bin_vector;
  }
  
  void output_time_bin_vector(const vector<int32_t> time_bin_vector,
                              const string tof_info_filename,
                              const bool debug)
  {
    size_t time_bin_vector_size = time_bin_vector.size();
    
    //reconvert axis in microS
    float * time_bin_array = new float [time_bin_vector_size];
    for (size_t i=0 ; i<time_bin_vector_size ; ++i)
      {
        time_bin_array[i] = static_cast<float>(time_bin_vector[i])/10.;
      }
    
    //write time_bin_vector into tof_info_filename
    ofstream tof_info_file(tof_info_filename.c_str(),
                           ios::binary);
    tof_info_file.write(reinterpret_cast<char*>(time_bin_array),
                        sizeof(float)*time_bin_vector_size);
    tof_info_file.close();
    
    return;
  }
  
}
