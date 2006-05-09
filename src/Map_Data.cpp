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
 * \file src/Map_Data.cpp
 */

#include "Map_Data.hpp"

using namespace std;
using namespace TCLAP;

int main(int argc, char **argv)
{
  
  try
    {
      CmdLine cmd("Command line description message", ' ', VERSION_TAG);

      ValueArg<string> neutronArg("n","neutron",
                                  "Name of neutron binary data file",
                                  true, "duh.dat", "filename");
      cmd.add(neutronArg);

      ValueArg<string> mapArg("m", "mapping", "Name of the mapping file", 
                              true, "map.dat", "filename");
      cmd.add(mapArg);

      ValueArg<int> pixelArg("p", "pixel", "Number of detector pixels", true,
                             -1, "# of pixels");
      cmd.add(pixelArg);

      ValueArg<int> tofArg("t", "tof", "Number of tof bins", true, -1, 
                           "# of tof bins");
      cmd.add(tofArg);

      cmd.parse(argc, argv);

      
      
    } 
  catch(ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}
