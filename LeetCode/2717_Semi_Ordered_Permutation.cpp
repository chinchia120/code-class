#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int semiOrderedPermutation(vector<int>& nums)
    {   
        int index1 = 0, index2 = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            if(nums[i] == 1) index1 = i;
            if(nums[i] == nums.size()) index2 = i;
        }

        if(index1 < index2) return index1+(nums.size()-1-index2);
        else return index2+(nums.size()-1-index1)+SwapCount(index2, index1);
    }

    int SwapCount(int index1, int index2)
    {   
        return 2*(index2-index1+1)-3;
    }
};