#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int mostFrequentEven(vector<int>& nums)
    {   
        sort(nums.begin(), nums.end());

        vector<vector<int>> NumFres;
        int maxFre = 0;
        for(int num: nums)
        {   
            if(num%2 == 0)
            {
                int flag = 0;
                for(int i = 0; i < NumFres.size(); i++)
                {
                    if(num == NumFres[i][0])
                    {
                        flag = 1;
                        NumFres[i][1]++;
                        maxFre = max(maxFre, NumFres[i][1]);
                        break;
                    }
                }

                if(flag == 0)
                {
                    NumFres.push_back(vector<int> ());
                    NumFres[NumFres.size()-1].push_back(num);
                    NumFres[NumFres.size()-1].push_back(1);
                    maxFre = max(maxFre, 1);
                }
            }
        }
        if(maxFre == 0) return -1;
        else for(vector<int> NumFre: NumFres) if(NumFre[1] == maxFre) return NumFre[0];
        return -1;
    }
};