#include <iostream>
#include <stdlib.h>
#include "napi.h"

using namespace std;

// FUNCTION: populate_rand_arr
// DESCRIPT: takes an array of n_rand size and populates
// it with random values
////
void populate_rand_arr(int * const arr, const int n_rand) {
  int i;

  for ( i=0; i<n_rand; i++ ) {
    arr[i] = rand();
  }
}

// FUNCTION: make_nexus_file
// DESCRIPT: Creates the nexus file and makes the groups
// and data for it
////
void make_nexus_file(const char * const name, NXhandle& file_id) {
  (void)NXopen("rand.nxl", NXACC_CREATE, &file_id);
  (void)NXmakegroup(file_id, "entry", "NXentry");
}

// FUNCTION: populate_nexus_file
// DESCRIPT: Populates the file with the information
////
void populate_nexus_file(NXhandle& file_id, int * const rand_tof_arr, int * const rand_pix_arr, int n_rand) {
  char var[12] = "10^-7second";

  (void)NXopengroup(file_id, "entry", "NXentry");
    (void)NXmakegroup(file_id, "bank1", "NXevent_data");
      (void)NXopengroup(file_id, "bank1", "NXevent_data");
        (void)NXmakedata(file_id, "time_of_flight", NX_INT32, 1, &n_rand);
          (void)NXopendata(file_id, "time_of_flight");
            (void)NXputdata(file_id, rand_tof_arr);
          (void)NXclosedata(file_id);
        (void)NXmakedata(file_id, "pixel_number", NX_INT32, 1, &n_rand);
          (void)NXopendata(file_id, "pixel_number");
            (void)NXputdata(file_id, rand_pix_arr);
            (void)NXputattr(file_id, "units", var, 11, NX_CHAR);
}

// FUNCTION: close_nexus_file
// DESCRIPT: Closes off any groups or data and then the file
////
void close_nexus_file(NXhandle& file_id) {
  (void)NXclosedata(file_id);
  (void)NXclosegroup(file_id);
  (void)NXclosegroup(file_id);
  (void)NXclose(&file_id);
}

int main(void) {
  int i, status, n_rand=10;
  int rand_tof_arr[n_rand];
  int rand_pix_arr[n_rand];
  NXhandle file_id;

  // Populate the random time of flight array
  populate_rand_arr(rand_tof_arr, n_rand);

  // Populate the random pixel id array
  populate_rand_arr(rand_pix_arr, n_rand);

  // Open nexus file and create initial items
  make_nexus_file("rand.nxl", file_id);

  // Populate the nexus file with information
  populate_nexus_file(file_id, rand_tof_arr, rand_pix_arr, n_rand);

  // Close off the nexus file and any groups or data
  close_nexus_file(file_id);

  return 0;
}
