#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int rob(vector<int>& nums)
    {   
        if(nums.size() == 1) return nums[0];
        if(nums.size() == 2) return max(nums[0], nums[1]);

        vector<int> dp (nums.size(), 0);
        dp[0] = nums[0];
        dp[1] = nums[1];

        int maxPrev = max(dp[0], dp[1]);
        for(int i = 2; i < nums.size(); i++)
        {   
            if(i == 2) dp[i] = max(dp[i-1], nums[i]+dp[i-2]);
            else dp[i] = max(dp[i-1], max(nums[i]+dp[i-2], nums[i]+dp[i-3]));
            //dp[i] = max(dp[i-1], max(nums[i]+dp[i-2], nums[i]+dp[i-3]));
            //maxPrev = max(maxPrev, dp[i-2]);
        }
        show_1d_vector(dp);
        return dp.back();
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    //vector<int> nums = {2,7,9,3,1};
    vector<int> nums = {2,1,1,2};
    Solution S;

    cout << S.rob(nums);

    return 0;
}