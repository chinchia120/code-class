#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int mostFrequent(vector<int>& nums, int key)
    {
        vector<int> count (1000, 0);
        int maxNum = 0, maxFre = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            if(nums[i] == key && i != nums.size()-1)
            {
                count[nums[i+1]-1]++;
                if(count[nums[i+1]-1] > maxFre)
                {
                    maxFre = count[nums[i+1]-1];
                    maxNum = nums[i+1];
                }
            }
        }
        return maxNum;
    }
};
