#ifndef _BANK_HPP
#define _BANK_HPP 1

#include <vector>

template <typename EventNumT, typename PulseNumT>
class Bank
{
  public:
  int pulse_index;
  std::vector<EventNumT> tof;
  std::vector<EventNumT> pixel_id;
  std::vector<PulseNumT> pulse_time;
  std::vector<PulseNumT> events_per_pulse;
  Bank()
    {
      this->pulse_index = -1;
    }
  ~Bank()
    {
    }
};

#endif
