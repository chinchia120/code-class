#include <iostream>
#include <vector>

using namespace std;

class Solution {
public:
    int minimumRightShifts(vector<int>& nums) {
        int ans = 0, flag = 0;
        for (int i = 1; i < nums.size(); i++)
        {
            if (nums[i] < nums[i-1])
            {
                flag++;
                ans++;
            }

            if (flag == 1 && nums[i] > nums[i-1])
            {
                ans++;
            }

            if (flag > 1)
            {
                return -1;
            }
        }
        return ans;
    }
};