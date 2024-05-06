#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int averageValue(vector<int>& nums)
    {   
        int sum = 0, cnt = 0;
        for(int num: nums)
        {
            if(num%6 == 0)
            {
                sum += num;
                cnt++;
            }
        }
        return (cnt == 0)? 0: sum/cnt;
    }
};