#include <cmath>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <sys/stat.h>
#include <vector>

using std::cout;
using std::endl;
using std::string;
using std::vector;

//Type of binary file
typedef int binary_type;

/* 
###############################################
This version only supports linear rebining
ex:
> Event_to_Histo DAS_3_neutron_event.dat 0.005
###############################################
*/

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

/*
  argv[1] : Name of file entered
  argv[2] : time bin width desired
*/

int main(int argc, char *argv[])
{
  struct stat results;
  int GlobalArraySize;
  vector<int> GlobalArray;
  int file_size;
  int pixelID;
  int time_stamp;
  int Histo_size;
  
  int Nx = 256;
  int Ny = 304;
  int Nt = 167;
  int new_Nt;

  char type_of_rebining = 'l';

  //Help option --help or --h

  if (argc>1)
    {
      if (argv[1][0]=='-' && argv[1][1]=='-' && argv[1][2]=='h')
        {
          cout << "usage: Event_to_Histo input_file_name -[ l | b | log]rebin_value"<<endl;
          cout << "\nArguments:\n\t -l: linear rebining\n\t\tex: Event_to_Histo Input_file_name -l200\n\t\tEach bin will be 200microseconds wide."<<endl;
          cout << "\t -d: double rebinning\n\t\tex: Event_to_Histo Input_file_name -d500\n\t\tThe first time bin will be 500microseconds wide and the second \n\t\ttime bin will contain the rest of the data. "<<endl;
          cout << "\t -log: logarithmic rebining\n\t\tex: Event_to_Histo Input_file_name -log350\n\t\tEach time bin width will be defined by delta(t)/t"<<endl;
          cout << endl;
          cout << "NB: The output file generated will have the same name as the input file with \n'event' replaced by 'histogram'"<<endl;
        }
    }
      // Name of file
      string file_name;
  string output_file_name;
  file_name = "DAS_3_neutron_event.dat";   //REMOVE

  produce_output_file_name(file_name,output_file_name);

  //  file_name = argv[1];   //REMOVE Comments
  
  // Rebining value
  float rebin_value;
  rebin_value =200;   // REMOVE
  //  rebin_value = argv[2];   //REMOVE Comments
  
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
    //  throw invalid_argument("Could not open file: " + file_name);
  cout << "Invalid Argument"<<endl;
  
  //allocate memory for the binary Array
  GlobalArraySize = file_size;
  binary_type * BinaryArray = new binary_type [GlobalArraySize];

  //transfer the data from the binary file into the GlobalArray
  fread(&BinaryArray[0],sizeof(BinaryArray[0]), GlobalArraySize, BinaryFile);

  // swap endian (PC <-> Mac)
  SwapEndian (file_size, BinaryArray);

  new_Nt = int(floor((Nt*100)/rebin_value));   //rebin_value=200 => Nt=83
  
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
      time_stamp = int(floor((BinaryArray[2*i]/1000)/rebin_value));
      data_histo[time_stamp+pixelID*new_Nt]+=1;      
    }
  
  // write new histogram file
  std::ofstream file("DAS_3_neutron_histo.dat", std::ios::binary);
  file.write((char*)(data_histo),sizeof(data_histo)*Histo_size);  
  file.close();
  
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
          time_stamp = int(floor((BinaryArray[2*i]/1000)/rebin_value));
          data_histo[time_stamp+pixelID*new_Nt]+=1;      
        }
      break;
    case 'd':
      break;
    case 'L':
      break;
    default:
      cout << "type of rebining not defined"<<endl;
    }
     
  return;
}
