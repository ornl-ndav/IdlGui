/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file NexusUtil.cpp
 *  \brief A bunch of wrapper functions for the nexus api. These
 *         functions are enclosed in a class and do all the 
 *         necessary error checking.
 */

#include "NexusUtil.hpp"

using std::runtime_error;
using std::string;

NexusUtil::NexusUtil(const string &out_path, 
                     const NXaccess &file_access)
{
  if (NXopen(out_path.c_str(), file_access, &file_id) != NX_OK)
    {
      throw runtime_error("Failed to open nexus file: "+out_path);
    }
}


NexusUtil::~NexusUtil(void)
{
  if (NXclose(&file_id) != NX_OK)
    {
      throw runtime_error("Failed to close nexus file");
    }
}

void NexusUtil::make_group(const string &name, const string &path)
{
  if (NXmakegroup(file_id, name.c_str(), path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to make group: "+name);
    }
}

void NexusUtil::open_group(const string &name, const string &path)
{
  if (NXopengroup(file_id, name.c_str(), path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open group: entry");
    }
}

void NexusUtil::close_group(void)
{
if (NXclosegroup(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group");
    }
}

void NexusUtil::open_path(const string &path)
{
  if (NXopenpath(file_id, path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open group: "+path);
    }
}

void NexusUtil::make_data(const string &name, 
                          int nexus_data_type, int rank, 
                          int *dimensions)
{
  if (NXmakedata(file_id, name.c_str(),
                 nexus_data_type, rank, dimensions) != NX_OK)
    {
      throw runtime_error("Failed make data: "+name);
    }
}

void NexusUtil::open_data(const string &name)
{
  if (NXopendata(file_id, name.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open data: "+name);
    }
}

void NexusUtil::put_data(void *nx_data)
{
  if (NXputdata(file_id, nx_data) != NX_OK)
    {
      throw runtime_error("Failed to create data");
    }
}

void NexusUtil::close_data(void)
{
  if (NXclosedata(file_id) != NX_OK)
    {
      throw runtime_error("Failed to close data");
    }
}

void NexusUtil::put_attr(const string &name, void *value, 
                          int length, int nx_type)
{
  if (NXputattr(file_id, name.c_str(),
                value, length,
                nx_type) != NX_OK)
    {
      throw runtime_error("Failed to create attribute: "+name);
    }
}

void NexusUtil::put_slab(void *nx_data, int *start, int *size)
{
  if (NXputslab(file_id, nx_data, start, size) != NX_OK)
    {
      throw runtime_error("Failed to create data chunk");
    }
}

void NexusUtil::get_data(void *nx_data)
{
  if (NXgetdata(file_id, nx_data) != NX_OK)
    {
      throw runtime_error("Failed to get data");
    }
}

void NexusUtil::get_slab(void *nx_data, int *start, int *size)
{
  if (NXgetslab(file_id, nx_data, start, size) != NX_OK)
    {
      throw runtime_error("Failed to get slab");
    }
}

void NexusUtil::malloc(void **nx_data, int rank, int *dimensions,
                       int nexus_data_type)
{
  if (NXmalloc(nx_data, rank, dimensions, nexus_data_type) != NX_OK)
    {
      throw runtime_error("Malloc failure");
    }
}

void NexusUtil::free(void **nx_data)
{
  if (NXfree(nx_data) != NX_OK)
    {
      throw runtime_error("Free failure");
    }
}

void NexusUtil::get_info(int *rank, int *dimensions, 
                         int *nexus_data_type)
{
  if (NXgetinfo(file_id, rank, dimensions, 
                nexus_data_type) != NX_OK)
    {
      throw runtime_error("Failed to get data information");
    }
}
