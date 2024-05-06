#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    vector<int> findColumnWidth(vector<vector<int>>& grid)
    {
        vector<int> MaxWidth (grid[0].size(), 0);
        for(int i = 0; i < grid[0].size(); i++)
        {
            for(int j = 0; j < grid.size(); j++)
            {   
                string str = to_string(grid[j][i]);
                int len = str.length();
                MaxWidth[i] = max(MaxWidth[i], len);
            }
        }
        return MaxWidth;
    }

    void Show1DVector(vector<int> nums)
    {
        for(int num: nums) cout << num << " ";
        cout << endl;
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
    //vector<vector<int>> grid = {{-15,1,3},{15,7,12},{5,6,-2}};
    vector<vector<int>> grid = {{1},{22},{333}};
    Solution S;

    S.Show1DVector(S.findColumnWidth(grid));

    return 0;
}