#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int differenceOfSum(vector<int>& nums)
    {
        int diff = 0;
        for(int num: nums)
        {   
            if(num >= 10)
            {
                int tmp = num, _num = num;
                while(_num != 0)
                {
                    tmp -= _num%10;
                    _num /= 10;
                }
                diff += tmp;
            }
        }
        return diff;
    }
};