#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<vector<int>> findDifference(vector<int>& nums1, vector<int>& nums2)
    {   
        sort(nums1.begin(), nums1.end());
        sort(nums2.begin(), nums2.end());

        vector<vector<int>> diff (2, vector<int> ());
        for(int num: nums1)
        {   
            int flag = 0;
            for(int i = 0; i < nums2.size(); i++)
            {
                if(num == nums2[i])
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0)
            {
                if(diff[0].empty()) diff[0].push_back(num);
                else if(num != diff[0].back()) diff[0].push_back(num);
            }
        }
        for(int num: nums2)
        {   
            int flag = 0;
            for(int i = 0; i < nums1.size(); i++)
            {
                if(num == nums1[i])
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0)
            {
                if(diff[1].empty()) diff[1].push_back(num);
                else if(num != diff[1].back()) diff[1].push_back(num);
            }
        }
        return diff;
    }
};
