#include "Event_to_Histo.hpp"

// $Id: Event_to_Histo.cpp 28 2006-05-02 17:45:45Z j35 $

using std::cout;
using std::endl;

int main(int argc, char *argv[])
{
  struct stat results;

  int file_size;
  int pixelID;
  int time_stamp;
  int Histo_size;
  int GlobalArraySize;
  int Nx = 256;
  int Ny = 304;
  int Nt = 16667;
  int new_Nt;
  
  float rebin_value;
  
  char type_of_rebining;

  // Name of file
  string path_file_name;
  string file_name;
  string output_file_name;
  string path;

  if (argc>1)  //if there is at least one argument
    {
      if (argv[1][0]=='-' && argv[1][1]=='-' && argv[1][2]=='h')
        {
          print_help();
          return 0;
        }
      else
        {
          type_of_rebining = argv[2][1];
          rebin_value = get_rebin_value(argv);
        }
    }

  path_file_name = argv[1];
  isolate_file_name(path_file_name,file_name,path);

  produce_output_file_name(file_name,output_file_name, path);

  // Open and Read binary file
  FILE *BinaryFile;
  BinaryFile=fopen(path_file_name.c_str(),"rb");
  
  // Get the size of the binary file
  if (stat(path_file_name.c_str(),&results)==0)
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
      break;
    case 'L':
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
      time_stamp = int(floor((BinaryArray[2*i]/10)/rebin_value)); 
      data_histo[time_stamp+pixelID*new_Nt]+=1;      
    }

  // write new histogram file
  std::ofstream file(output_file_name.c_str(), std::ios::binary);
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
                              string & output_file,
                              string & path)
{
  int file_name_size = file_name.size();
  string local_file_name = file_name;
  int index;

  index = file_name.find("event");
  
  output_file = path + local_file_name.substr(0,index) + "histo" + \
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
  cout << "usage: Event_to_Histo input_file_name(relative path) -[ l | b | L]rebin_value"<<endl;
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
 as the input file with \n'event' replaced by 'histo'"<<endl;
  return;
}

/*******************************************
/ get the rebin value
/*******************************************/
float get_rebin_value(char *argv[])
{
  string my_string = argv[2];
  float rebin_value;

  my_string = my_string.substr(2,5); 
  rebin_value = atof(my_string.c_str());

  return rebin_value;
}

/*******************************************
/ Isolate file_name from path+file_name
/*******************************************/
void isolate_file_name(string & path_file_name,
                       string & file_name,
                       string & path)
{
  string local_file_name = path_file_name;
  vector<int> index;
  int i=0;
  
  index.push_back(local_file_name.find("/",0));
  if (index[0]<0)
    {
      path = "./";
      file_name = path_file_name;
    }
  else
    {
      while(index[i]>=0)
        {
          index.push_back(local_file_name.find("/",index[i]+1));
          i++;
        }
    }
  
  path = path_file_name.substr(0,index[i-1]+1);
  file_name = path_file_name.substr(index[i-1]+1,path_file_name.size());
      
  return;
}

