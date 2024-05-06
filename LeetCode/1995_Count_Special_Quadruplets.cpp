#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countQuadruplets(vector<int>& nums)
    {
        int cnt = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            for(int j = i+1; j < nums.size(); j++)
            {
                for(int k = j+1; k < nums.size(); k++)
                {
                    for(int l = k+1; l < nums.size(); l++)
                    {   
                        if(nums[i]+nums[j]+nums[k] == nums[l]) cnt++;
                    }
                }
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {28,8,49,85,37,90,20,8};
    Solution S;

    cout << S.countQuadruplets(nums);

    return 0;
}