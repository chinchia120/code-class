#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int minimumSum(int num)
    {
        vector<int> nums (4, 0);
        for(int i = 0; i < 4; i++)
        {
            nums[i] = num%10;
            num /= 10;
        }
        sort(nums.begin(), nums.end());

        return nums[0]*10+nums[2] + nums[1]*10+nums[3]; 
    }
};