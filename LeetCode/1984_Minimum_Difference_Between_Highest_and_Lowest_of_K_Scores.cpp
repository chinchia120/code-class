#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int minimumDifference(vector<int>& nums, int k)
    {   
        if(k == 1) return 0;

        sort(nums.begin(), nums.end());
        int minDif = INT32_MAX;
        for(int i = 0; i < nums.size()-k+1; i++)
        {   
            minDif = min(minDif, nums[i+k-1]-nums[i]);
        }
        return minDif;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {9,4,1,7};
    int k = 3;
    Solution S;

    cout << S.minimumDifference(nums, k);

    return 0;
}