#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int findFinalValue(vector<int>& nums, int original)
    {
        sort(nums.begin(), nums.end());

        int init = original;
        for(int i = 0; i < nums.size(); i++)
        {   
            if(init == nums[i]) init *= 2;
            else if(init*2 < nums[i]) return init;
        }
        return init;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {5,3,6,1,12};
    int original = 3;
    Solution S;

    cout <<S.findFinalValue(nums, original);

    return 0;
}