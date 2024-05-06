#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int deleteGreatestValue(vector<vector<int>>& grid)
    {
        for(int i = 0; i < grid.size(); i++) sort(grid[i].begin(), grid[i].end());
        //Show2DVector(grid);

        int sum = 0;
        for(int i = 0; i < grid[0].size(); i++)
        {
            int MaxTmp = 0;
            for(int j = 0; j < grid.size(); j++) MaxTmp = max(MaxTmp, grid[j][i]);
            sum += MaxTmp;
        }
        return sum;
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
    vector<vector<int>> grid = {{1,2,4},{3,3,1}};
    Solution S;

    cout << S.deleteGreatestValue(grid);

    return 0;
}