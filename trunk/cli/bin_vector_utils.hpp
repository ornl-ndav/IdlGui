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

/**
 * $Id$
 *
 * \file bin_vector_utils.hpp
 */

#ifndef _BIN_VECTOR_UTILS_HPP
#define _BIN_VECTOR_UTILS_HPP 1

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include "utils.hpp"
#include <vector>

/**
 * \namespace BinVectorUtils
 *
 * \brief This sub-library contains various functions that allows to generate
 * linear and logarithmic time binning axis and output these axis into a
 * binary file
 */
namespace BinVectorUtils
{
  /**
   * \brief This function determine the minimum time bin from the input array
   *
   * \param binary_array (INPUT) is the input binary array
   * \param size_array (INPUT) is the size of the binary array
   *
   * \returns
   * It returns the minimum time bin
   */
  int32_t get_minimum_time_bin(const int32_t * binary_array,
                               const size_t size_array);

  /**
   * \defgroup generate_linear_time_bin_vector
   * BinVectorUtils::generate_linear_time_bin
   * \{
   */

  /**
   * \brief This function creates the vector of a linear time bins widths 
   * (units is x100ns).
   * For example, for a time bin of 25micros, the first values of the vector
   * will be 0, 250, 500, 750....
   *
   * The time bin boundaries are calculated according to the equation
   * \f[
   * T[i]=T_{offset}+\delta T*i
   * \f]
   *
   * \param max_time_bin_100ns (INPUT) is the maximum time bin (x100ns)
   * \param time_rebin_width_100ns (INPUT) is the rebin value (x100ns)
   * \param time_offset_100ns (INPUT) is the starting offset time (x100ns)
   * \param debug (INPUT) is a switch that trigger or not the debugging tools
   * \param verbose (INPUT) is a flag for printing processing info
   *
   * \returns A vector of the time bin values.
   */
  std::vector<int32_t> 
  generate_linear_time_bin_vector(const int32_t max_time_bin_100ns,
                                  const int32_t time_rebin_width_100ns,
                                  const int32_t time_offset_100ns,
                                  const bool debug,
                                  const bool verbose);

  /**
   * \}
   */ // end of generate_lineara_time_bin_vector

  /**
   * \defgroup generate_log_time_bin_vector 
   * BinVectorUtils::generate_log_time_bin_vector
   * \{
   */
  
  /**
   * \brief This function creates the vector of a logarithmic time bins 
   * percentage
   *
   * The time bin boundaries are calculated according to the equation
   * \f[
   * T_0 = T_{offset}
   * T_i = T_{i-1}(coeff+1)
   * \f]
   *
   * \param max_time_bin_100ns (INPUT) is the maximum time bin (x100ns)
   * \param log_rebin_coeff_100ns (INPUT) is the rebin coefficient (10 times
   * the coefficient from the command line in order to work with x100ns data
   * \param time_offset_100ns (INPUT) is the starting offset time (x100ns)
   * \param minimum_time_bin_100ns (INPUT) is the minimum time bin from the 
   * binary data file (x100ns)
   * \param debug (INPUT) is a switch that trigger or not the debugging tools
   * \param verbose (INPUT) is a flag for printing processing info
   *
   * \returns vector of the time bin values.
   */
  std::vector<int32_t> 
  generate_log_time_bin_vector(const int32_t max_time_bin_100ns,
                               const float log_rebin_coeff_100ns,
                               const int32_t time_offset_100ns,
                               const int32_t minimum_time_bin_100ns,
                               const bool debug,
                               const bool verbose);
  /**
   * \}
   */ // end of generate_log_time_bin_vector

  /** 
   * /defgroup output_time_bin_vector BinVectorUtils::output_time_bin_vector
   * \{
   */

  /**
   * \brief This function output of the time_bin_vector into a file called
   * tof_info_filename
   *
   * \param time_bin_vector (INPUT) is the vector of the time bin values
   * \param tof_info_filename (INPUT) is the name of the file that will
   * contain the time bin values
   * \param debug (INPUT) is a switch that trigger or not the debugging tools
   * \param verbose (INPUT) is a flat for printing processing info
   *
   * \returns vector of the time bin values.
   */
  void 
  output_time_bin_vector(const std::vector<int32_t> time_bin_vector,
                         const std::string tof_info_filename,
                         const bool debug,
                         const bool verbose);
  /**
   * \}
   */ // end of output_time_bin_vector

}  // BinVectorUtils

#endif // _BIN_VECTOR_UTILS_HPP
