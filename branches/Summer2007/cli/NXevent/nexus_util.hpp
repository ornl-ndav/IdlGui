/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file nexus_util.hpp
 *  \brief The class declaration and prototypes for
 *         NexusUtil.cpp.
 */

#ifndef _NEXUS_UTIL_HPP
#define _NEXUS_UTIL_HPP 1

#include "napi.h"
#include <string>
#include <vector>

/** \enum e_nx_access
 *  \brief Enumeration for the types of nexus file
 *         access. This allows the compiler to 
 *         check for errors.
 */
typedef enum e_nx_access 
{ 
  READ = NXACC_READ, 
  RDWR = NXACC_RDWR, 
  CREATE = NXACC_CREATE, 
  HDF_FOUR = NXACC_CREATE4, 
  HDF_FIVE = NXACC_CREATE5, 
  XML = NXACC_CREATEXML 
};

/** \class NexusUtil
 *  \brief A nexus utility that opens a file in the
 *         constructor and stores the file handle
 *         as a private variable. The functions also
 *         do appropriate error checking.
 */
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
    NexusUtil(const std::string &out_path, 
              const e_nx_access file_access);

    /** \fn ~NexusUtil(void)
     *  \brief Destructor that closes the nexus file.
     */
    ~NexusUtil(void);

    /** \fn make_group(const string &name, 
     *                 const string &path)
     *  \brief Makes a group in a nexus file, while checking for
     *         errors.
     */
    void make_group(const std::string &name, 
                    const std::string &path);
    
    /** \fn open_group(const string &name, 
     *                 const string &path)
     *  \brief Opens a group in a nexus file, while checking for
     *         errors.
     */
    void open_group(const std::string &name,  
                    const std::string &path);
    
    /** \fn close_group(void)
     *  \brief Closes a group in a nexus file, while checking for
     *         errors.
     */
    void close_group(void);
    
    /** \fn open_path(const string &path)
     *  \brief Opens a path in a nexus file, while checking for
     *         errors.
     */
    void open_path(const std::string &path);
    
    /** \fn make_data(const string &name, 
     *                int nexus_data_type,
     *                int rank,
     *                int *dimensions)
     *  \brief Makes data in a nexus file, while checking for
     *         errors.
     */
    void make_data(const std::string &name, 
                   int nexus_data_type, 
                   int rank, 
                   int *dimensions);
    
    /** \fn open_group(const string &name)
     *  \brief Opens data in a nexus file, while checking for
     *         errors.
     */
    void open_data(const std::string &name);
    
    /** \fn put_data(void *nx_data)
     *  \brief Writes data to a nexus file, while checking for
     *         errors.
     */
    void put_data(void *nx_data);

    /** 
     *  \brief Writes data to a nexus file, while checking for
     *         errors.
     *  \param nx_data The vector of data to be written to the
     *                 nexus file.
     */
    template <typename NumT>
    void put_data(const std::vector<NumT> & nx_data);
    
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
    void put_attr(const std::string &name, 
                  void *value, 
                  int length, 
                  int nx_type);

    /** \fn put_attr(const string &name,
     *               const string &value);
     *  \brief Overloaded function that is specifically
     *         meant for strings.
     */
    void put_attr(const std::string &name,
                  const std::string &value);
    
    /** \fn put_slab(void *nx_data,
     *               int start,
     *               int size)
     *  \brief Writes a chunk of data to a nexus file, 
     *         while checking for errors.
     */
    void put_slab(void *nx_data, 
                  int *start,
                  int *size);

    /**
     *  \brief Writes a chunk of a vector to a nexus file, 
     *         while checking for errors.
     *  \param nx_data The vector of data.
     *  \param start The starting index in the vector.
     *  \param block_size The size of the chunk of data to 
     *                    be written.
     */
    template <typename NumT>
    void NexusUtil::put_slab(std::vector<NumT> & nx_data, 
                             int start,
                             int block_size);

    /**
     *  \brief Writes all the data using put_slab and a loop
     *         with a given block size. Also error checks.
     *  \param nx_data The data to be written.
     *  \param block_size The size of the blocks to write to the
     *                    file.
     */
    template <typename NumT>
    void NexusUtil::put_data_with_slabs(std::vector<NumT> & nx_data,
                                        int block_size);

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
