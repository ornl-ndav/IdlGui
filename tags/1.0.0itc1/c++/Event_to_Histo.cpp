#include <cmath>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <sys/stat.h>
#include <vector>
#include <time.h>
//#include <stdio.h>
//#include <stdlib.h>

using std::cout;
using std::endl;
using std::string;
using std::vector;

//Type of binary file
typedef int binary_type;

//to swap from little to big endian
inline void endian_swap(binary_type & x);  

void SwapEndian (int file_size, 
                 binary_type * BinaryArray);

// Initialize Array
void InitializeArray(binary_type  * data_histo, 
                     int Nx, 
                     int Ny,
                     int new_nt);

// Generate the name of the output file
void produce_output_file_name(string & file_name,
                              string & output_file);

// Generate histogram
void Generate_data_histo(binary_type * data_histo,
                         binary_type * BinaryArray, 
                         int GlobalArraySize, 
                         char type_of_rebining,
                         float rebin_value,
                         int new_Nt);

// Print the help menu
void print_help();

// Get the rebin value
float get_rebin_value(char *argv[]);

// Calculate the resulting time bin array for the logarithmic rebining case
void Calculate_time_bin_array(binary_type * BinaryArray, 
                              float rebin_value, 
                              vector<float> & time_bin_array,
                              const int GlobalArraySize,
                              int & new_Nt);

// find minimum and maximum time stamp values
void determine_min_timestamp(binary_type * BinaryArray, 
                             float & time_min,
                             float & time_max,
                             const int GlobalArraySize);

//  argv[1] : Name of file entered
//  argv[2] : time bin width desired

int main(int argc, char *argv[])
{
  struct stat results;

  // array of the bin boundaries generated in the logarithmic rebining case
  vector<float> time_bin_array; 
  
  int file_size;
  int pixelID;
  int time_stamp;
  int Histo_size;
  int GlobalArraySize;
  int Nx = 256;
  int Ny = 304;
  int Nt = 167;
  int new_Nt;
  
  float rebin_value;
  
  char type_of_rebining;

  // Name of file
  string file_name;
  string output_file_name;
  
  //char type_of_rebining = 'd';  //REMOVE
  
  if (argc>1)  //if there is at least one argument
    {
      if (argv[1][0]=='-' && argv[1][1]=='-' && argv[1][2]=='h')
        {
          print_help();
        }
      else
        {
          type_of_rebining = argv[2][1];
          rebin_value = get_rebin_value(argv);
        }
    }

  //file_name = "DAS_3_neutron_event.dat";   //REMOVE
  file_name = argv[1];   //REMOVE Comments
  
  produce_output_file_name(file_name,output_file_name);

  // Rebining value (in microSeconds)
  //rebin_value =2;   // REMOVE

  // Open and Read binary file
  FILE *BinaryFile;
  BinaryFile=fopen(file_name.c_str(),"rb");

  // Get the size of the binary file
  if (stat("DAS_3_neutron_event.dat",&results)==0)
    {
      file_size = results.st_size/sizeof(binary_type);
    }
  else
    throw std::logic_error("Can't determine the size of the file");
  
  // check that open was successful
  if (BinaryFile==NULL)
    throw std::invalid_argument("Could not open file: " + file_name);
  
  //allocate memory for the binary Array
  GlobalArraySize = file_size;
  binary_type * BinaryArray = new binary_type [GlobalArraySize];
  
  //transfer the data from the binary file into the GlobalArray
  fread(&BinaryArray[0],sizeof(BinaryArray[0]), GlobalArraySize, BinaryFile);
  
  // swap endian (PC <-> Mac)
  SwapEndian (file_size, BinaryArray);
  
  switch (type_of_rebining)
    {
    case 'l':
      new_Nt = int(floor((Nt)/rebin_value));   //rebin_value=2 => Nt=83
      break;
    case 'd':
      new_Nt = 2;
      break;
    case 'L':
      new_Nt = 0 ;
      Calculate_time_bin_array(BinaryArray, 
                               rebin_value, 
                               time_bin_array,
                               GlobalArraySize,
                               new_Nt);
      break;
    }

  Histo_size = Nx*Ny*new_Nt;
  binary_type *data_histo = new binary_type[Histo_size];
  
  //initialize array
  InitializeArray(data_histo, Nx, Ny, new_Nt);
  
  Generate_data_histo(data_histo,
                      BinaryArray, 
                      GlobalArraySize, 
                      type_of_rebining,
                      rebin_value,
                      new_Nt);
  
  for (int i=0; i<GlobalArraySize/2; i++)
    {
      pixelID = BinaryArray[2*i+1];
      // "/10" to be in micro_seconds
      time_stamp = int(floor((BinaryArray[2*i]/10)/rebin_value)); 
      data_histo[time_stamp+pixelID*new_Nt]+=1;      
    }
  
  /*

  // write new histogram file
  std::ofstream file("DAS_3_neutron_histo.dat", std::ios::binary);
  file.write((char*)(data_histo),sizeof(data_histo)*Histo_size);  
  file.close();
  
  //  cout << "It took " << clock()<<" to run it"<<endl;
  
  */

  return 0;
}

/*********************************************
/Loop through BinaryArray to swap all endians
/********************************************/
void SwapEndian (int file_size, binary_type * BinaryArray)
{
  for (int j=0; j<file_size; ++j)
    {
      endian_swap(BinaryArray[j]);
    }
  
  return;
}

/*******************************************
/To swap from little endian to big endian
/*******************************************/
inline void endian_swap (binary_type & x)
{
  x = ((x>>24) & 0x000000FF) |
    ((x<<8) & 0x00FF0000) |
    ((x>>8) & 0x0000FF00) |
    ((x<<24) & 0xFF000000);
}

/*******************************************
/Initialize the array
/*******************************************/
void InitializeArray(binary_type * data_histo, 
                     int Nx, 
                     int Ny,
                     int new_Nt)
{
  int size = Nx*new_Nt*Ny;
  
  for (int a=0; a<size;++a)
    {
      data_histo[a]=0;
     }
  
  return;   
}

/*******************************************
/Generate the name of the output file
/*******************************************/
void produce_output_file_name(string & file_name,
                              string & output_file)
{
  int file_name_size = file_name.size();
  string local_file_name = file_name;
  int index;

  index = file_name.find("event");
  
  output_file = local_file_name.substr(0,index) + "histogram" + \
    file_name.substr(index+5,file_name_size);

  return;
}

/*******************************************
/Generate the name of the output file
/*******************************************/
void Generate_data_histo(binary_type * data_histo,
                         binary_type * BinaryArray, 
                         int GlobalArraySize, 
                         char type_of_rebining,
                         float rebin_value,
                         int new_Nt)
{
  int pixelID;
  int time_stamp;

  switch(type_of_rebining)
    {
    case 'l':   
      for (int i=0; i<GlobalArraySize/2; i++)
        {
          pixelID = BinaryArray[2*i+1];
          time_stamp = int(floor((BinaryArray[2*i]/10)/rebin_value));
          data_histo[time_stamp+pixelID*new_Nt]+=1;      
        }
      break;
    case 'd':
      for (int i=0; i<GlobalArraySize/2; i++)
        {
          pixelID = BinaryArray[2*i+1];
          if ((BinaryArray[2*i]/10)<rebin_value)
            {
              data_histo[pixelID]+=1;
            }
          else
            {
              data_histo[pixelID+1]+=1;
            }
        }
      break;
    case 'L':
      break;
    default:
      cout << "type of rebining not defined"<<endl;
    }
     
  return;
}

/*******************************************
/ print the help menu (--help or -h)
/*******************************************/
void print_help()
{
  cout << "usage: Event_to_Histo input_file_name -[ l | b | L]rebin_value"<<endl;
  cout << "\nArguments:\n\t -l: linear rebining\n\t\tex: \
Event_to_Histo Input_file_name -l2\n\t\tEach bin will be 2 microseconds \
wide."<<endl;
  cout << "\t -d: double rebinning\n\t\tex: Event_to_Histo \
Input_file_name -d5\n\t\tThe first time bin will be 5 microseconds \
wide and the second \n\t\ttime bin will contain the rest of the data. "<<endl;
  cout << "\t -L: logarithmic rebining\n\t\tex: Event_to_Histo\
 Input_file_name -log3.5\n\t\tEach time bin width will be defined by\
 delta(t)/t=3.5"<<endl;
  cout << endl;
  cout << "NB: The output file generated will have the same name\
 as the input file with \n'event' replaced by 'histogram'"<<endl;
  return;
}

/*******************************************
/ get the rebin value
/*******************************************/
float get_rebin_value(char *argv[])
{
  string my_string = argv[2];
  float rebin_value;

  my_string = my_string.substr(2,5);  //remove "-l"

  rebin_value = atof(my_string.c_str());

  return rebin_value;
}

/*******************************************
/ Calculate the resulting time bin array for 
/ the logarithmic rebining case
/*******************************************/
void Calculate_time_bin_array(binary_type * BinaryArray, 
                              float rebin_value, 
                              vector<float> & time_bin_array,
                              const int GlobalArraySize,
                              int & new_Nt)
{
  float time_min;
  float time_max;
  float time_range_max;
  float time_range_min;

  determine_min_timestamp(BinaryArray,
                          time_min,
                          time_max,
                          GlobalArraySize);

  cout << "\ttime_min= " << time_min <<endl;
  cout << "\ttime_max= " << time_max <<endl;

  time_range_max = time_min;
  time_range_min = time_min;
  
  time_bin_array.push_back(time_min);

  while (time_range_max < time_max)
    {
      time_range_max = (rebin_value + 1 ) * time_range_min;
      time_bin_array.push_back(time_range_max);
      time_range_min = time_range_max;
      new_Nt++;
    }
  
  cout << "new_Nt= " << new_Nt << endl;

  for (int i=0; i<new_Nt; i++)
    {
      cout << "time_bin_array["<<i<<"]= " << time_bin_array[i]<<endl;
    }
  
  return;
}

/*******************************************
/ find minimum and maximum time stamp values
/*******************************************/
void determine_min_timestamp(binary_type * BinaryArray, 
                             float & time_min,
                             float & time_max,
                             const int GlobalArraySize)
{
  time_min = BinaryArray[0];
  time_max = BinaryArray[0];

  for (int i=1; i<GlobalArraySize/2; i++)
    {
      if (time_min > BinaryArray[2*i])
        {
          time_min = BinaryArray[2*i];
        }
      if (time_max < BinaryArray[2*i])
        {
          time_max = BinaryArray[2*i];
        }
    }
  return;
}
