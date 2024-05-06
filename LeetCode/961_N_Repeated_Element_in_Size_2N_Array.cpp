#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int repeatedNTimes(vector<int>& nums)
    {
        vector<int> check = {nums[0]};
        for(int i = 1; i < nums.size(); i++)
        {   
            int flag = 0;
            for(int j = 0; j < check.size(); j++)
            {
                if(nums[i] == check[j])
                {
                    flag = 1;
                    break;
                }
            }

            if(flag == 1) return nums[i];
            else check.push_back(nums[i]);
        }
        return nums[0];
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {2,1,2,5,3,2};
    Solution S;

    cout << S.repeatedNTimes(nums);

    return 0;
}

