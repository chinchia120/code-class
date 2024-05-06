#include <iostream>
#include <vector>
using namespace std;

class Solution 
{
public:
    vector<int> twoSum(vector<int>& nums, int target) 
    {
        vector<int> ans;
        for(int i = 0; i < nums.size(); i++)
        {
            for(int j = i+1; j < nums.size(); j++)
            {
                if(nums[i] + nums[j] == target)
                {
                    ans.push_back(i);
                    ans.push_back(j);
                }
            }
        }
        return ans;
    }
};

int main(int argc, char **argv)
{
    vector<int> demo = {2, 7, 11, 15};
    int target = 9;
    Solution S;
    vector<int> ans = S.twoSum(demo, target);
    
    for(int i = 0; i < ans.size(); i++)
    {
        cout << ans[i] << " ";
    }
}