#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countNegatives(vector<vector<int>>& grid)
    {
        int cnt = 0;
        for(int i = 0; i < grid.size(); i++)
        {
            for(int num: grid[i])
            {
                if(num < 0) cnt++;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> grid = {{4,3,2,-1},{3,2,1,-1},{1,1,-1,-2},{-1,-1,-2,-3}};
    Solution S;

    cout << S.countNegatives(grid);

    return 0;
}