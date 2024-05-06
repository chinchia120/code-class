#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> rowAndMaximumOnes(vector<vector<int>>& mat)
    {
        vector<int> RowCount (2, 0);
        for(int i = 0; i < mat.size(); i++)
        {   
            int cnt = 0;
            for(int j = 0; j < mat[i].size(); j++)
            {
                if(mat[i][j] == 1) cnt++;
            }

            if(cnt > RowCount[1]) RowCount = {i, cnt};
        }
        return RowCount;
    }
};