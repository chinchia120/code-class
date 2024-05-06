#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool findRotation(vector<vector<int>>& mat, vector<vector<int>>& target)
    {
        vector<vector<int>> matRotation = mat;
        for(int i = 0; i < 4; i++)
        {   
            if(matRotation == target) return true;
            for(int j = 0; j < matRotation.size(); j++)
            {
                for(int k = 0; k < matRotation[j].size(); k++)
                {
                    matRotation[j][k] = mat[mat.size()-1-k][j];
                }
            }
            mat = matRotation;
        }
        return false;
    }

    void show_2d_vector(vector<vector<int>> vec)
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
    vector<vector<int>> mat = {{0,0,0},{0,1,0},{1,1,1}}, target = {{1,1,1},{0,1,0},{0,0,0}};
    Solution S;

    cout << S.findRotation(mat, target);

    return 0;
}