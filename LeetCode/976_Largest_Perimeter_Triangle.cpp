#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int largestPerimeter(vector<int>& nums)
    {
        sort(nums.begin(), nums.end());

        for(int i = nums.size()-1; i >=2; i--)
        {   
            if(nums[i] < nums[i-1]+nums[i-2]) return nums[i]+nums[i-1]+nums[i-2];
        }
        
        return 0;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {1,2,1,10};
    Solution S;

    cout << S.largestPerimeter(nums);

    return 0;
}