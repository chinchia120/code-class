#include <iostream>
using namespace std;

class Solution
{
public:
    int findDelayedArrivalTime(int arrivalTime, int delayedTime)
    {
        int time = arrivalTime+delayedTime;
        return (time >= 24)? time-24: time;
    }
};