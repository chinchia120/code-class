#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int surfaceArea(vector<vector<int>>& grid)
    {
        int xy = 0, xz = 0, yz = 0;
        for(int i = 0; i < grid.size(); i++)
        {   
            int max_row = 0;
            for(int j = 0; j < grid[i].size(); j++)
            {
                if(grid[i][j] > 0) xy++;
                if(grid[i][j] > max_row) max_row = grid[i][j];
            }
            xz += max_row; 
        }

        for(int j = 0; j < grid[0].size(); j++)
        {   
            int max_column = 0;
            for(int i = 0; i < grid.size(); i++)
            {
                if(grid[i][j] > max_column) max_column = grid[i][j];
            }
            yz += max_column;
        }

        return 2*(xy+xz+yz);
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> grid = {{1, 2}, {3, 4}};
    Solution S;

    cout << S.surfaceArea(grid);

    return 0;
}