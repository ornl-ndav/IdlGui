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
 * \file cli/Map_Data.cpp
 */

#include "Map_Data.hpp"
#include "utils.hpp"

using namespace std;
using namespace TCLAP;

/**
 * \brief This program takes a binary data file, a mapping file and creates 
 *        a mapped binary data file.
 *
 * This program takes a neutron binary data file, a pixel mapping file and 
 * creates a mapped neutron binary data file. The number of detector pixels 
 * and number of time-of-flight channels must be provided to the program. An 
 * alternate path for the create binary data file can be provided. For usage 
 * of the program do
 * <code>
 * Map_Data -h 
 * </code>
 * or
 * <code>
 * Map_Data --help 
 * </code>
 *
 * \param argc
 * \param **argv
 * 
 * \return An integer status number
 */
int main(int argc, char **argv)
{
  try
    {
      // Setup the command-line parser object
      CmdLine cmd("Command line description message", ' ', 
                  EventHisto::VERSION_TAG);

      // Add command-line options
      ValueArg<string> neutronArg("n","neutron",
                                  "Name of neutron binary data file",
                                  true, "duh.dat", "filename", cmd);

      ValueArg<string> mapArg("m", "mapping", "Name of the mapping file", 
                              true, "map.dat", "filename", cmd);

      ValueArg<int32_t> pixelArg("p", "pixel", "Number of detector pixels", 
                                 true, -1, "# of pixels", cmd);
      
      ValueArg<int32_t> tofArg("t", "tof", "Number of tof bins", true, -1, 
                               "# of tof bins", cmd);

      SwitchArg debugSwitch("d", "debug", "Flag for debugging program", 
                              false, cmd);

      ValueArg<string> altOutPath("o", "output", 
                                  "Alternate path for output file", 
                                  false, "", "path", cmd);

      // Parse the command-line
      cmd.parse(argc, argv);

      // Create the pixel map
      map<int32_t, int32_t> pixel_map;
      pixel_map = make_pixel_map(mapArg.getValue(), pixelArg.getValue(), 
                                 debugSwitch.getValue());

      // Create the mapped binary data
      create_mapped_data(neutronArg.getValue(),
                         make_mapped_filename(neutronArg.getValue(),
                                              altOutPath.getValue(),
                                              debugSwitch.getValue()),
                         tofArg.getValue(), pixel_map, 
                         debugSwitch.getValue());
      
    } 
  catch(ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}

