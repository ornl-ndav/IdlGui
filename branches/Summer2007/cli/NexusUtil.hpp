/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file NexusUtil.hpp
 *  \brief The class declaration and prototypes for
 *         NexusUtil.cpp.
 */

#ifndef _NEXUS_UTIL_HPP
#define _NEXUS_UTIL_HPP

#include "napi.h"
#include <string>
#include <stdexcept>

using std::string;

class NexusUtil
{
  private:
    NXhandle file_id;
  public:
    /** \fn NexusUtil(const string &out_path, 
     *                const NXaccess &file_access)
     *  \brief Constructor that opens the nexus file with the 
     *         specified format.
     */
    NexusUtil(const string &out_path, 
              const NXaccess &file_access);

    /** \fn ~NexusUtil(void)
     *  \brief Destructor that closes the nexus file.
     */
    ~NexusUtil(void);

    /** \fn make_group(const string &name, 
     *                 const string &path)
     *  \brief Makes a group in a nexus file, while checking for
     *         errors.
     */
    void make_group(const string &name, 
                    const string &path);
    
    /** \fn open_group(const string &name, 
     *                 const string &path)
     *  \brief Opens a group in a nexus file, while checking for
     *         errors.
     */
    void open_group(const string &name,  
                    const string &path);
    
    /** \fn close_group(void)
     *  \brief Closes a group in a nexus file, while checking for
     *         errors.
     */
    void close_group(void);
    
    /** \fn open_path(const string &path)
     *  \brief Opens a path in a nexus file, while checking for
     *         errors.
     */
    void open_path(const string &path);
    
    /** \fn make_data(const string &name, 
     *                int nexus_data_type,
     *                int rank,
     *                int *dimensions)
     *  \brief Makes data in a nexus file, while checking for
     *         errors.
     */
    void make_data(const string &name, 
                   int nexus_data_type, 
                   int rank, 
                   int *dimensions);
    
    /** \fn open_group(const string &name)
     *  \brief Opens data in a nexus file, while checking for
     *         errors.
     */
    void open_data(const string &name);
    
    /** \fn put_data(void *nx_data)
     *  \brief Writes data to a nexus file, while checking for
     *         errors.
     */
    void put_data(void *nx_data);
    
    /** \fn close_data(void)
     *  \brief Closes data in a nexus file, while checking for
     *         errors.
     */
    void close_data(void);
    
    /** \fn put_attr(const string &name,
     *               void *value,
     *               int length,
     *               int nx_type)
     *  \brief Writes an attribute to a piece of data, 
     *         while checking for errors.
     */
    void put_attr(const string &name, 
                  void *value, 
                  int length, 
                  int nx_type);
    
    /** \fn put_slab(void *nx_data,
     *               int start,
     *               int size)
     *  \brief Writes a chunk of data to a nexus file, 
     *         while checking for errors.
     */
    void put_slab(void *nx_data, 
                  int *start,
                  int *size);

    /** \fn get_data(void *nx_data)
     *  \brief Gets data from the nexus file, 
     *         while checking for errors.
     */
    void get_data(void *nx_data);
    
    /** \fn get_slab(void *nx_data,
     *               int *start,
     *               int *size)
     *  \brief Gets a chunk of data from the nexus file, 
     *         while checking for errors.
     */
    void get_slab(void *nx_data, 
                  int *start, 
                  int *size);

    /** \fn malloc(void **nx_data,
     *             int rank,
     *             int *dimensions,
     *             int nexus_data_type)
     *  \brief Uses NXmalloc, while checking for errors.
     */
    void malloc(void **nx_data,
                int rank,
                int *dimensions,
               int nexus_data_type);

    /* \fn free(void **nx_data)
     * \brief Calls NXfree, while checking for errors.
     */
    void free(void **nx_data);

    /* \fn get_info(int *rank,
     *              int *dimensions,
     *              int *nexus_data_type)
     * \brief Gets nexus data information, 
     *        while checking for errors.
     */
    void get_info(int *rank,
                  int *dimensions,
                  int *nexus_data_type);
};

#endif
