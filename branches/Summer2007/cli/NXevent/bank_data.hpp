#ifndef _BANK_DATA_HPP
#define BANK_DATA_HPP 1

#include "bank.hpp"
#include <string>
#include <vector>
#include <libxml/tree.h>

/**
 * \class BankData
 * \brief Contains the bank data along with the functions to parse
 *        the bank file.
 */
template <typename EventNumT, typename PulseNumT>
class BankData
{
  private:
   /**
    * \brief Holds the pointers to the banks. This vector is keyed
    *        on the bank's number.
    */
    std::vector<Bank<EventNumT, PulseNumT> *> banks;

    /**
     * \brief The vector used when finding out what bank a pixel id
     *        belongs to.
     */
    std::vector<Bank<EventNumT, PulseNumT> *> bank_map;
    
    /**
     * \brief When a step list is found in a banking configuration 
     *        file, this function is used to parse the values from
     *        it and store them.
     * \param bank_node The root node of the step list in the xml tree.
     * \param bank_number The number of the bank.
     * \exception runtime_error Thrown when an invalid number is read in 
     *                          or when a parsing error occurs.
     */
    void create_step_list(xmlNodePtr bank_node,
                          const int bank_number);

    /**
     * \brief When a continuous list is found in a banking configuration 
     *        file, this function is used to parse the values from
     *        it and store them.
     * \param bank_node The root node of the continuous list in the xml 
     *                  tree.
     * \param bank_number The number of the bank.
     * \exception runtime_erro Thrown when an invalid number is read in 
     *                         or when a parsing error occurs.
     */
    void create_cont_list(xmlNodePtr bank_node,
                          const int bank_number);

    /**
     * \brief When an arbitrary list is found in a banking configuration 
     *        file, this function is used to parse the values from
     *        it and store them.
     * \param bank_node The root node of the arbitrary list in the xml 
     *                  tree.
     * \param bank_number The number of the bank.
     * \exception runtime_error Thrown when an invalid number is read in 
     *                          or when a parsing error occurs.
     */
    void create_arbitrary(xmlNodePtr bank_node, int bank_number);
    
    /**
     * \brief Takes a single pixel number and adds it to the bank map. 
     * \param number The string representing the pixel number.
     * \param bank_number The number of the bank the pixel will be 
     *                    mapped to.
     * \exception 
     */
    void add_to_bank_map(const std::string & number,
                         const int bank_number);

    void add_to_bank_map(const std::string & start,
                         const std::string & stop,
                         const int bank_number);

    void add_to_bank_map(const std::string & start,
                         const std::string & stop,
                         const std::string & step,
                         const int bank_number);


  public:
    std::vector<int> bank_numbers;

    Bank<EventNumT, PulseNumT> * get_bank_by_pixel_id(const EventNumT pixel_id);

    Bank<EventNumT, PulseNumT> * get_bank_by_bank_number(const int bank_number);

    BankData(const std::string & bank_file);

    ~BankData();
};

#endif
