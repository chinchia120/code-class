#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<vector<int>> mergeArrays(vector<vector<int>>& nums1, vector<vector<int>>& nums2)
    {
        vector<vector<int>> mergeArray = nums1;
        for(vector<int> num2: nums2)
        {   
            int flag = 0;
            for(int i = 0; i < mergeArray.size(); i++)
            {
                if(mergeArray[i][0] == num2[0])
                {
                    flag = 1;
                    mergeArray[i][1] += num2[1];
                    break;
                }
            }
            
            if(flag == 0) mergeArray.push_back(num2);
        }
        sort(mergeArray.begin(), mergeArray.end());

        return mergeArray;
    }
};