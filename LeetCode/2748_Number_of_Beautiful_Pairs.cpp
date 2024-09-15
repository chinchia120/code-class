#include <iostream>
#include <vector>
#include <numeric>
#include <string>
using namespace std;

class Solution
{
public:
    int countBeautifulPairs(vector<int>& nums)
    {
        int cnt = 0;
        for (int i = 0; i < nums.size(); i++)
        {
            for (int j = i+1; j < nums.size(); j++)
            {
                int first = to_string(nums[i]).at(0) - '0';
                int last = nums[j] % 10;
                // cout << first << " " << last << endl;
                if (gcd (first, last) == 1) cnt++;
            }
        }
        return cnt;
    }
};