#ifndef _BANK_HPP
#define _BANK_HPP 1

#include <vector>

/** class Bank
 * \brief Holds all of the information for a bank. This includes
 *        the pulse information and the event information.
 */
template <typename EventNumT, typename PulseNumT>
class Bank
{
  public:
  /**
   * \brief The pulse_index is used to keep track of how many pulses
   *        have been read in.
   */
  int pulse_index;
  /** 
   * \brief The time of flight vector.
   */
  std::vector<EventNumT> tof;
  /** 
   * \brief The pixel id vector.
   */
  std::vector<EventNumT> pixel_id;
  /**
   * \brief The vector that holds the pulse time offsets from the
   *        original time.
   */
  std::vector<PulseNumT> pulse_time;
  /**
   * \brief The events per pulse vector.
   */
  std::vector<PulseNumT> events_per_pulse;
  /**
   * \brief The constructor for the bank class. It initializes the
   *        pulse index to -1 to indicate no pulses have been read in.
   */
  Bank()
    {
      this->pulse_index = -1;
    }
  /**
   * \brief The destructor for the bank class.
   */
  virtual ~Bank()
    {
    }
};

#endif
