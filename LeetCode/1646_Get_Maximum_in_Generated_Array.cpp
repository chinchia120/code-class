#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int getMaximumGenerated(int n)
    {
        if(n == 0) return 0;
        if(n == 1) return 1;

        vector<int> nums (n+1, 0);
        nums[1] = 1;

        int maxNum = 0;
        for(int i = 2; i <= n; i++)
        {
            if(i%2 == 0) nums[i] = nums[i/2];
            if(i%2 == 1) nums[i] = nums[(i-1)/2] + nums[(i-1)/2+1];
            maxNum = max(maxNum, nums[i]);
        }
        return maxNum;
    }
};

int main(int argc, char **argv)
{
    int n = 0;
    Solution S;

    cout << S.getMaximumGenerated(n);

    return 0;
}