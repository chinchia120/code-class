#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> transpose(vector<vector<int>>& matrix)
    {
        vector<vector<int>> matrix_inv;
        for(int i = 0; i < matrix.size(); i++)
        {
            for(int j = 0; j < matrix[i].size(); j++)
            {
                if(i == 0)
                {
                    matrix_inv.push_back(vector<int> ());
                    matrix_inv[j].push_back(matrix[i][j]);
                }
                else
                {
                    matrix_inv[j].push_back(matrix[i][j]);
                }
            }
        }
        return matrix_inv;
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
    vector<vector<int>> matrix = {{1,2,3},{4,5,6},{7,8,9}};
    Solution S;

    S.show_2d_vector(S.transpose(matrix));

    return 0;
}