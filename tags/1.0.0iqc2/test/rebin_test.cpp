#include <fstream>
#include <iostream>
#include <string>
#include "tclap/CmdLine.h"

using namespace std;
using namespace TCLAP;

static const string IN_EXT=".dat";
static const string OUT_EXT="_rebinned.dat";
static const size_t DATA_ITEM_SIZE=sizeof(uint32_t);
static const size_t MAX_BLOCK_SIZE=10000;

uint32_t calculate_bin( const uint32_t *data, const size_t offset,
                       const size_t num_bins)
{
  uint32_t result=data[offset];
  for( size_t i=1 ; i<num_bins ; ++i )
    {
      result+=data[i];
    }
  return result;
}

void process_block( ifstream &infile, ofstream &outfile,
                    uint32_t *buffer, const size_t buffer_size,
                    const size_t num_bins, const size_t file_offset)
{
      // read in the data
      infile.seekg(file_offset,ios::beg);
      infile.read(reinterpret_cast<char *>(buffer),
                  buffer_size);

      // calculate the new bin value and write it to the file
      uint32_t rebinned_number;
      for( size_t i=0 ; i<buffer_size ; i+=num_bins )
        {
          rebinned_number=calculate_bin(buffer,i,num_bins);
          outfile.write(reinterpret_cast<char *>(&rebinned_number),
                        DATA_ITEM_SIZE);
        }
}

/**
 * \brief This program takes an event binary file and according to the 
 * arguments provided, creates a histo binary file.
 */
int32_t main(int32_t argc, char *argv[])
{
  // Setup the command-line parser object
  CmdLine cmd("Command line description message");

  UnlabeledValueArg<string> infileArg("filename",
                                        "Name of a file to be viewed",
                                        "filename","filename",cmd);
  ValueArg<size_t> numBinsArg("","num_bins",
                              "Number of bins to sum together",
                              true,0,"# of bins",cmd);
  ValueArg<string> outfileArg("o","output",
                              "Name of output file, defaults to insert \"rebinned\" in the file name",
                              false,"","filename",cmd);

  string infilename;
  string outfilename;
  size_t num_bins;
  try
    {
      // Parse the command-line
      cmd.parse(argc, argv);

      // get the information out of the command line
      infilename=infileArg.getValue();
      outfilename=outfileArg.getValue();
      num_bins=numBinsArg.getValue();

      // fix the output filename if not provided
      if( outfilename.empty() )
        {
          string::size_type index=infilename.find(IN_EXT);
          outfilename=infilename.substr(0,index)+OUT_EXT;
        }
    }
  catch (ArgException &e)
    {
      cerr << "ERROR: " << e.error() << " for arg " << e.argId() << endl;
      return -1;
    }
  
  // open the input file
  ifstream infile(infilename.c_str(),ios::binary);
  if(!(infile.is_open()))
    {
      cout << "ERROR: Failed to open file \"" << infilename << "\"" << endl;
      return -1;
    }

  // check that the rebin size is one or greater
  if(num_bins<=0)
    {
      cout << "ERROR: num_bins argument (" << num_bins
           << ") must be greater than zero" << endl;
      return -1;
    }

  // determine the file size
  infile.seekg(0,std::ios::end);
  size_t file_size_bytes=infile.tellg();
  size_t file_size=file_size_bytes/DATA_ITEM_SIZE;

  // check that the binning choice can work
  if( (file_size%num_bins)!=0 )
    {
      cout << "ERROR: Invalid rebinning size " << file_size << "/" << num_bins
           << "=" << (file_size/num_bins) << "+(" << (file_size%num_bins)
           << "/" << num_bins << ")" << endl;
      return -1;
    }

  // open the output file
  ofstream outfile(outfilename.c_str(),ios::binary);
  if(!outfile.is_open())
    {
      cout << "ERROR: Failed to open file \"" << outfilename << "\"" << endl;
      return -1;
    }

  // create a data buffer for reading in
  size_t block_size=MAX_BLOCK_SIZE-(MAX_BLOCK_SIZE%num_bins);
  size_t buffer_size=sizeof(uint32_t)*block_size;
  size_t block_counter=0;
  bool last=false;
  uint32_t data_buffer[block_size];

  // process a chuck from the file - the logic here is incorrectly formed
  while(true)
    {
      process_block(infile,outfile,data_buffer,block_size,num_bins,block_counter);
      if(last)
        {
          break;
        }
      block_counter+=block_size;
      if(block_counter+block_size>file_size)
        {
          block_size=file_size-block_counter;
          last=true;
        }
    }

  // return success
  return 0;
}


                        
