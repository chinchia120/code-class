#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int lengthOfLIS(vector<int>& nums)
    {
        vector<int> dp (nums.size(), 1);
        for(int i = 1; i < nums.size(); i++)
        {   
            int max_len = 1, flag = 0;
            for(int j = i-1; j >= 0; j--)
            {   
                if(nums[i] > nums[j])
                {
                    flag = 1;
                    max_len = max(max_len, dp[j]);
                }
            }
            (flag == 1) ? dp[i] = max_len+1 : dp[i] = 1;
        }
        return *max_element(dp.begin(), dp.end());
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {10,9,2,5,3,7,101,18};
    Solution S;

    cout << S.lengthOfLIS(nums);

    return 0;
}