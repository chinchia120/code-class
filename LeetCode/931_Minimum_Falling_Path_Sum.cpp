#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minFallingPathSum(vector<vector<int>>& matrix)
    {
        int indexCol = 0, minNum = INT32_MAX, minSum = INT32_MAX;
        for(int i = 0; i < matrix[matrix.size()-1].size(); i++)
        {
            minNum = matrix[matrix.size()-1][i];
            indexCol = i;

            vector<int> dp;
            dp.push_back(minNum);
            for(int j = matrix.size()-2; j >= 0; j--)
            {
                int col1 = indexCol-1, col2 = indexCol, col3 = indexCol+1, minNum = 0;
                if(col1 < 0) col1 = 0;
                if(col3 > matrix[j].size()-1) col3 = matrix[j].size()-1;

                if(matrix[j][col1] <= matrix[j][col2] && matrix[j][col1] <= matrix[j][col3])
                {
                    minNum = matrix[j][col1];
                    indexCol = col1;
                }
                else if(matrix[j][col2] <= matrix[j][col1] && matrix[j][col2] <= matrix[j][col3])
                {
                    minNum = matrix[j][col2];
                    indexCol = col2;
                }
                else
                {
                    minNum = matrix[j][col3];
                    indexCol = col3;
                }
                //cout << dp.back() << " " << minNum << endl;
                dp.push_back(dp.back()+minNum);
            }
            minSum = min(minSum, dp.back());
        }
        return minSum;    
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> matrix = {{2,1,3},{6,5,4},{7,8,9}};
    Solution S;

    cout << S.minFallingPathSum(matrix);

    return 0;
}