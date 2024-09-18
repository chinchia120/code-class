#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int numberOfEmployeesWhoMetTarget(vector<int>& hours, int target)
    {
        int cnt = 0;
        for (int hour: hours) if (hour >= target) cnt++;
        return cnt;
    }
};