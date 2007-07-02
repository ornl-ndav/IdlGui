#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>

using std::vector;
using std::string;
using std::cerr;
using std::cout;
using std::endl;
using std::ifstream;
using std::runtime_error;

const string VERSION = "1.0";
const size_t BLOCK_SIZE = 1024;
const uint32_t ERROR = 0x80000000;

void compare_data(const vector<uint32_t> &file_one_data,
                  const vector<uint32_t> &file_two_data)
{
  if (file_one_data.size() != file_two_data.size())
    {
      cout << "Files differ" << endl;
    }
  else
    {
      int size = file_one_data.size();
      for (int i = 0; i < size; i++)
        {
          if (*(&file_one_data[0] + i) != *(&file_two_data[0] + i))
            {
              cout << "Files differ" << endl;
              return;
            }
        }
    }
}

void read_data(const string &file_name, 
          vector<uint32_t> &data)
{
  uint32_t buffer[BLOCK_SIZE];
  size_t offset = 0;
  size_t i;
  size_t data_size = sizeof(uint32_t);

  // Open the event file
  ifstream file(file_name.c_str(), std::ios::binary);
  if(!(file.is_open()))
    {
      throw runtime_error("Failed opening file: "+file_name);
    }

  // Determine the file and buffer size
  file.seekg(0, std::ios::end);
  size_t file_size = file.tellg() / data_size;
  size_t buffer_size = (file_size < BLOCK_SIZE) ? file_size : BLOCK_SIZE;

  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  while(offset < file_size)
    {
      file.read(reinterpret_cast<char *>(buffer), buffer_size * data_size);

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for( i = 0; i < buffer_size; i+=2 )
        {
          // Filter out error codes
          if ((*(buffer + i + 1) & ERROR) != ERROR)
            {
              // Use pointer arithmetic for speed
              data.push_back(*(buffer + i));
              data.push_back(*(buffer + i + 1));
            }
        }

      offset += buffer_size;

      // Make sure to not read past EOF
      if(offset+BLOCK_SIZE > file_size)
        {
          buffer_size = file_size-offset;
        }
    }

  // Close event file
  file.close();
}

int main(int32_t argc, 
         char *argv[]) 
{
  vector<uint32_t> file_one_data;
  vector<uint32_t> file_two_data;

  if (argc != 3)
    {
      cerr << "usage: nxl_diff file1 file2" << endl;
      exit(1);
    }
  string file_one(argv[1]);
  string file_two(argv[2]);

  read_data(file_one, file_one_data);
  read_data(file_two, file_two_data);
  compare_data(file_one_data, file_two_data);

  return 0;
}
