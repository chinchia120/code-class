#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> onesMinusZeros(vector<vector<int>>& grid)
    {
        vector<int> ones_row, zeros_row;
        for(int i = 0; i < grid.size(); i++)
        {   
            int one = 0, zero = 0;
            for(int j = 0; j < grid[i].size(); j++)
            {
                if(grid[i][j] == 0) zero++; 
                if(grid[i][j] == 1) one++;
            }
            ones_row.push_back(one);
            zeros_row.push_back(zero);
        }

        vector<int> ones_col, zeros_col;
        for(int j = 0; j < grid[0].size(); j++)
        {   
            int one = 0, zero = 0;
            for(int i = 0; i < grid.size(); i++)
            {   
                if(grid[i][j] == 0) zero++;
                if(grid[i][j] == 1) one++;
            }
            ones_col.push_back(one);
            zeros_col.push_back(zero);
        }

        vector<vector<int>> diff;
        for(int i = 0; i < grid.size(); i++)
        {   
            for(int j = 0; j < grid[i].size(); j++)
            {
                if(j == 0) diff.push_back(vector<int> ());
                diff[i].push_back(ones_row[i]+ones_col[j]-zeros_row[i]-zeros_col[j]);
            }
        }

        return diff;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
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
    vector<vector<int>> grid = {{0, 1, 1}, {1, 0, 1}, {0, 0, 1}};
    Solution S;

    S.show_2d_vector(S.onesMinusZeros(grid));

    return 0;
}