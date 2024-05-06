#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool checkXMatrix(vector<vector<int>>& grid)
    {
        for(int i = 0; i < grid.size(); i++)
        {
            for(int j = 0; j < grid[i].size(); j++)
            {
                if((i == j || i == grid.size()-1-j) && grid[i][j] == 0) return false;
                if(!(i == j || i == grid.size()-1-j) && grid[i][j] != 0) return false;
            }
        }
        return true;
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> grid = {{2,0,0,1},{0,3,1,0},{0,5,2,0},{4,0,0,2}};
    Solution S;

    cout << S.checkXMatrix(grid);

    return 0;
}