#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maximizeSum(vector<int>& nums, int k)
    {
        int Maxnum = 0;
        for(int num: nums) Maxnum = max(Maxnum, num);

        int sum = 0;
        for(int i = Maxnum; i < Maxnum+k; i++) sum += i;
        return sum;
    }
};