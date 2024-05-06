#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> shiftGrid(vector<vector<int>>& grid, int k)
    {   
        k %= grid.size()*grid[0].size();

        vector<vector<int>> grid_shift = grid;
        for(int i = 0; i < grid.size(); i++)
        {
            for(int j = 0; j < grid[i].size(); j++)
            {   
                int new_row = i, new_col = j;
                for(int l = 0; l < k; l++)
                {
                    new_col++;
                    if(new_col == grid[i].size())
                    {
                        new_col = 0;
                        new_row++;
                    }
                    if(new_row == grid.size()) new_row = 0;
                }

                grid_shift[new_row][new_col] = grid[i][j];
            }
        }
        return grid_shift;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(int i = 0; i < vec.size(); i++)
        {
            for(int j = 0; j < vec[i].size(); j++) cout << vec[i][j] << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    //vector<vector<int>> grid = {{3,8,1,9},{19,7,2,5},{4,6,11,10},{12,0,21,13}};
    //int k = 4;
    vector<vector<int>> grid = {{1,2,3},{4,5,6},{7,8,9}};
    int k = 9;
    Solution S;

    S.show_2d_vector(S.shiftGrid(grid, k));

    return 0;
}