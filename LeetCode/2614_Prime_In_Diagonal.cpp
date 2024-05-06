#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int diagonalPrime(vector<vector<int>>& nums)
    {
        int MaxNum = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            for(int j = 0; j < nums.size(); j++)
            {
                if(i == j || i == nums.size()-1-j || j == nums.size()-1-i)
                {   
                    if(nums[i][j] > MaxNum)
                    {   
                        int flag = 0;
                        for(int k = 2; k < nums[i][j]; k++)
                        {
                            if(nums[i][j]%k == 0)
                            {
                                flag = 1;
                                break;
                            }
                        }
                        if(flag == 0) MaxNum = max(MaxNum, nums[i][j]);
                    }
                }
            }
        }
        if(MaxNum == 1) return 0;
        else return MaxNum;
    }
};