#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> largestLocal(vector<vector<int>>& grid)
    {
        vector<vector<int>> maxLocal (grid.size()-2, vector<int> (grid.size()-2, 0));
        for(int i = 0; i < maxLocal.size(); i++)
        {
            for(int j = 0; j < maxLocal[i].size(); j++)
            {   
                int maxNum = 0;
                for(int k = i; k < i+3; k++)
                {
                    for(int l = j; l < j+3; l++) maxNum = max(maxNum, grid[k][l]);
                }
                maxLocal[i][j] = maxNum;
            }
        }
        return maxLocal;
    }

    void Show2DVector(vector<vector<int>> vec)
    {
        for(vector<int> nums: vec)
        {
            for(int num: nums) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> grid = {{9,9,8,1},{5,6,2,6},{8,2,6,4},{6,2,2,2}};
    Solution S;

    S.Show2DVector(S.largestLocal(grid));

    return 0;
}