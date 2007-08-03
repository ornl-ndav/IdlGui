#include <vector>

template <typename NumT>
class Bank
{
  public:
  int pulse_index;
  std::vector<NumT> tof;
  std::vector<NumT> pixel_id;
  std::vector<NumT> pulse_time;
  std::vector<NumT> events_per_pulse;
  Bank()
    {
      this->pulse_index = -1;
    }
  ~Bank()
    {
    }
};
