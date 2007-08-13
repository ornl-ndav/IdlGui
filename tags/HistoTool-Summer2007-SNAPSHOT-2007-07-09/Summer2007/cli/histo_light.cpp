#include <iostream>
#include <cstdlib>
#include "napi.h"
#include <tclap/CmdLine.h>
#include <string>
#include <vector>

using std::string;
using std::cerr;
using std::endl;
using std::vector;

using namespace TCLAP;


   // create Nexus files
 void create_nexus_files(NXhandle &file_id)
{

  int rank = 1, size[1000];
  int var =  NX_INT32;
  int i;
  double boundaries = 1.0;

  char time_of_flight[20] = "time_of_flight";
  char pixel_number[20] = "pixel_number";
  char histogram[20] = "histogram";
  void *tof, *pixel_id;

  NXopen("rand2nxl.nxl", NXACC_READ, &file_id);
   NXopengroup(file_id, "entry", "NXentry");
    NXopengroup(file_id, "bank1", "NXevent_data");
     NXopendata(file_id, time_of_flight);
       NXgetinfo(file_id, &rank, size, &var);
       NXmalloc((void **) &tof, rank, size, NX_INT32);
       NXgetdata(file_id, tof);
      NXclosedata(file_id);
     NXclosegroup(file_id);
    NXclosegroup(file_id);
     
   NXopengroup(file_id, "entry", "NXentry");
    NXopengroup(file_id, "bank1", "NXevent_data");
      NXopendata(file_id, pixel_number);
       NXgetinfo(file_id, &rank, size, &var);
       NXmalloc((void **) &pixel_id, rank, size, NX_INT32);
       NXgetdata(file_id, pixel_id);
     NXclosedata(file_id);
    NXclosegroup(file_id);
   NXclosegroup(file_id);
  NXclose(&file_id);

  for (i =0; i < 10; i++) {
    printf("%d\n", ((int32_t *)tof)[i]);
   }
 }


 int main( )
{

   NXhandle file_id;
    const string VERSION("1.0");

   create_nexus_files(file_id);
    
  return 0;
}
	
