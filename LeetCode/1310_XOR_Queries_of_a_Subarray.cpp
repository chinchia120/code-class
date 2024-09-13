#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> xorQueries(vector<int>& arr, vector<vector<int>>& queries)
    {   
        vector<int> xorList;
        for (vector<int> query: queries)
        {   
            int xorNum;
            for(int i = query[0]; i < query[1]-1; i++)
            {
                xorNum = arr[i] ^ arr[i+1];
            }
            xorList.push_back(xorNum);
        }
        return xorList;
    }
};