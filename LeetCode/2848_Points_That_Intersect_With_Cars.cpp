#include <iostream>
#include <vector>

using namespace std;

class Solution {
public:
    int numberOfPoints(vector<vector<int>>& nums) {
        vector<bool> isCar(101, false);

        for (int i = 0; i < nums.size(); i++)
        {
            for (int j = nums[i][0]; j <= nums[i][1]; j++)
            {
                isCar[j] = true;
            }
        }

        int cnt = 0;
        for (int i = 0; i < isCar.size(); i++)
        {
            if (isCar[i])
            {
                cnt++;
            }
        }

        return cnt;
    }
};