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
 * \file utils.hpp
 */

#ifndef _UTILS_HPP
#define _UTILS_HPP 1

// this is a string that contains the new part of the binary data file
static const std::string HISTO_FILE_TAG("histo.dat");

// this is a string that contains the software tag version
static const std::string VERSION_TAG("1.0.0iqc1");

// This is a constant to hold the size of an int32_t
static const size_t SIZEOF_INT32_T = sizeof(int32_t);

// This is a constant to hold the size of an uint32_t
static const size_t SIZEOF_UINT32_T = sizeof(uint32_t);

// This is a constant to hold the "zero" value for the DAS
static const float SMALLEST_TIME_BIN = 0.01;

/**
 * \brief This function swap endians of an array
 * 
 * \param file_size (INPUT) is the size of the array
 * \param array (INPUT/OUTPUT) is the array to be swapped
*/
template <typename NumT>
void swap_endian(const int32_t file_size,
                 NumT * array);

/**
 * \brief This function swap endians of digits
 *
 * \param x (INPUT/OUTPUT) is the digit to be swapped
 */
template <typename NumT>
inline void swap_digit (NumT & x);


/**
 * \brief This function displays the n first element of an array
 *
 * \param array (INPUT) is the array for which we need to display
 * the first n elements
 * \param n_disp (INPUT) is the number of element to display
 * \param string_message (INPUT) is the message to display before the n_disp
 * elements
 */
void print32_t_n_first_data(const int32_t * array,
                            const int32_t n_disp,
                            const std::string message);

/**
 * \brief This function parse the name of the event binary file and 
 * parse it to isolate the path from the name of the file
 * 
 * \param path_filename (INPUT) is the complete name of the event binary file
 * \param filename (INPUT) is the name of the file (without the path part)
 * \param path (INPUT) is the path to the file (without the name part)
 * \param alternate_path (INPUT) is the alternate path for the output file
 * \param output_filename (OUTPUT) is the output file name with its path
 * \param output_debug_filename (OUTPUT) is the output file name of the 
 * debugging file
 * \param debug (INPUT) is a flag for printing debugging info
*/
void path_input_output_file_names(std::string & path_filename,
                                  std::string & filename,
                                  std::string & path,
                                  std::string & alternate_path,
                                  std::string & output_filename,
                                  std::string & output_debug_filename,
                                  const bool debug);

/**
 * \brief This function isolate the path from the file name
 *
 * \param path_filename (INPUT) is the complete name of the input file 
 * (path + name)
 * \param filename (OUTPUT) is the name part only of the input file
 * \param path (OUTPUT) is the path name only of the input file
 * \param debug (INPUT) is a flag for printing debugging info
 */
void parse_input_file_name(std::string & path_filename,
                           std::string & filename,
                           std::string & path,
                           const bool debug);

/**
 * \brief This function produce the complete name of the output file
 * 
 * \param filename (INPUT) is the name part only of the input file
 * \param path (INPUT) is the path part only of the input file
 * \param alternate_path (INPUT) is the alternate path provided on the 
 * command line for the output file name
 * \param output_filename (OUTPUT) is  the complete name (path + name) of the
 * output file
 * \param debug (INPUT) is a flag for printing debugging info
*/
void produce_output_file_name(std::string & filename,
                              std::string & path,
                              std::string & alternate_path,
                              std::string & output_filename,
                              const bool debug);

/**
 * \brief This function read the event binary file and populate the 
 * binary_array with its values
 * 
 * \param input_file (INPUT) is the name of the event binary file
 * \param input_filename (INPUT) is the complete name of the event binary file
 * \param swap_input (INPUT) is a flag that trigger the swapping of the data
 * coming from the event binary file
 * \param debug (INPUT) is a flag for printing debugging info
 * \param n_disp (INPUT) is the number of element to display for debugging
 * purpose only
 * \param binary_array (OUTPUT) is the array of the event binary data
 */
int32_t read_event_file_and_populate_binary_array(const 
                                                  std::string & input_file,
                                                  const 
                                                  std::string & input_filename,
                                                  const bool swap_input,
                                                  const bool debug,
                                                  uint32_t * &binary_array);


#endif // _UTILS_HPP
