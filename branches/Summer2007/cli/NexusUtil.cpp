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

NexusUtil::NexusUtil(const string &out_path, const string &format)
{
  NXaccess file_access;

  // Get the format of the nexus file
  if (format == "hdf4")
    {
      file_access = NXACC_CREATE4;
    }
  else if (format =="hdf5")
    {
      file_access = NXACC_CREATE5;
    }
  else if (format == "xml")
    {
      file_access = NXACC_CREATEXML;
    }
  else
    {
      throw runtime_error("Invalid nexus format type: "+format);
    }

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

void NexusUtil:: put_attr(const string &name, void *value, 
                          int length, int nx_type)
{
  if (NXputattr(file_id, name.c_str(),
                value, length,
                nx_type) != NX_OK)
    {
      throw runtime_error("Failed to create attribute: "+name);
    }
}
