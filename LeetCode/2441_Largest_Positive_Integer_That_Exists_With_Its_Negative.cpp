#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int findMaxK(vector<int>& nums)
    {   
        int MaxK = -1;
        vector<vector<int>> NumPosNegs;
        for(int num: nums)
        {
            int flag = 0;
            for(int i = 0; i < NumPosNegs.size(); i++)
            {
                if(abs(num) == NumPosNegs[i][0])
                {
                    flag = 1;
                    if(num > 0) NumPosNegs[i][1]++;
                    if(num < 0) NumPosNegs[i][2]++;
                    if(NumPosNegs[i][1] > 0 && NumPosNegs[i][2] > 0 && NumPosNegs[i][0] > MaxK) MaxK = NumPosNegs[i][0];
                    break;
                }
            }

            if(flag == 0)
            {
                NumPosNegs.push_back(vector<int> ());
                NumPosNegs[NumPosNegs.size()-1].push_back(abs(num));

                if(num > 0)
                {
                    NumPosNegs[NumPosNegs.size()-1].push_back(1);
                    NumPosNegs[NumPosNegs.size()-1].push_back(0);
                }
                if(num < 0)
                {
                    NumPosNegs[NumPosNegs.size()-1].push_back(0);
                    NumPosNegs[NumPosNegs.size()-1].push_back(1);
                }
            }
        }
        return MaxK;
    }
};