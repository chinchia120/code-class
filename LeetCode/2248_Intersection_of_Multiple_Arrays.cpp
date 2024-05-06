#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> intersection(vector<vector<int>>& nums)
    {
        vector<vector<int>> NumCounts;
        int index = 0;
        for(vector<int> num: nums)
        {
            for(int _num: num)
            {
                int flag = 0;
                for(int i = 0; i< NumCounts.size(); i++)
                {
                    if(NumCounts[i][0] == _num) 
                    {
                        flag = 1;
                        NumCounts[i][1]++;
                        break;
                    }
                }
                if(flag == 0)
                {
                    NumCounts.push_back(vector<int> ());
                    NumCounts[index].push_back(_num);
                    NumCounts[index].push_back(1);
                    index++;
                }
            }
        }

        vector<int> same;
        for(vector<int> NumCount: NumCounts)
        {
            if(NumCount[1] == nums.size()) same.push_back(NumCount[0]);
        }
        sort(same.begin(), same.end());

        return same;
    }
};