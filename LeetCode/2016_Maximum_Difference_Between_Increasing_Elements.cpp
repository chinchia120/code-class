#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maximumDifference(vector<int>& nums)
    {
        int maxDif = -1;
        for(int i = 0; i < nums.size(); i++)
        {
            for(int j = i+1; j < nums.size(); j++)
            {
                if(nums[j]-nums[i] > 0) maxDif = max(maxDif, nums[j]-nums[i]);
            }
        }
        return maxDif;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {1,5,2,10};
    Solution S;

    cout << S.maximumDifference(nums);

    return 0;
}