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
static const std::string VERSION_TAG("1.0.0itc1");

// This is a constant to hold the size of an uint32_t
static const int32_t SIZEOF_INT32_T = sizeof(int32_t);



/*********************************************
/ loop through BinaryArray to swap all endians
/********************************************/
void swap_endian (int32_t file_size, int32_t * BinaryArray);

/*******************************************
/ to swap from little endian to big endian
/*******************************************/
inline void swap_digit (int32_t & x);

/*************************************************
/ to plot the n first data of the specified array
/*************************************************/
void print32_t_n_first_data(const int32_t * binary_array,
                        const int32_t n_disp,
                        const std::string message);

/*******************************************
/ Isolate file_name from path+file_name
/ and generate output file name
/*******************************************/
void path_input_output_file_names(std::string & path_filename,
                                  std::string & filename,
                                  std::string & path,
                                  std::string & alternate_path,
                                  std::string & output_filename,
                                  bool debug);

/*******************************************
/ Isolate path and file_name from command line argument
/*******************************************/
void parse_input_file_name(std::string & path_filename,
                           std::string & filename,
                           std::string & path,
                           bool debug);

/*******************************************
/ Generate the name of the output file
/*******************************************/
void produce_output_file_name(std::string & filename,
                              std::string & path,
                              std::string & alternate_path,
                              std::string & output_filename,
                              bool debug);

/*******************************************
/ Read event file and create binary_array
/*******************************************/
int32_t read_event_file_and_populate_binary_array(const std::string & input_file,
                                                  const std::string & input_filename,
                                                  const bool swap_input,
                                                  const bool debug,
                                                  const int32_t n_disp,
                                                  int32_t * &binary_array);

#endif // _UTILS_HPP
