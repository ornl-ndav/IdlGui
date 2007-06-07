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
#include "ctime"  //REMOVE_ME

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
      cout << "\r.done\n";
    }
  
  return;
}

void generate_histo_old_way(const size_t array_size,
                            const int32_t new_Nt,
                            const int32_t pixel_number,
                            const int32_t * binary_array,
                            uint32_t * histo_array,
                            const size_t histo_array_size,
                            const int32_t max_time_bin_100ns,
                            const int32_t time_offset_100ns,
                            const int32_t time_rebin_width_100ns,
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
      cout << "\n\n**In generate_histo (the old way)**\n\n";
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

  for (size_t i=0 ; i<array_size/2; i++) 
  {
    if (verbose && !debug)
      {
        processing_percent = (2*i*100/array_size);
        cout << "\r" << processing_percent << "%";
      }

    pixelid = binary_array[2 * i + 1];
    time_stamp = binary_array[2*i];
    time_bin = int(floor(time_stamp/time_rebin_width_100ns));

    if (debug)
      {
        cout << "#" << i << "\t";
        cout << "Pid= " << pixelid << "\t";
        cout << "t_ms= " << time_stamp <<"\t";
        cout << "tstamp_value= " << time_stamp << "\t";
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
      cout << "\r.done\n";
    }
  
  return;
}

