#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> findMatrix(vector<int>& nums)
    {
        vector<vector<int>> matrix;
        int index = 0;
        for(int i = 0; i < nums.size(); i++)
        {   
            int flag1 = 0;
            for(int row = 0; row < matrix.size(); row++)
            {   
                int flag2 = 0;
                for(int col = 0; col < matrix[row].size(); col++)
                {
                    if(nums[i] == matrix[row][col])
                    {
                        flag2 = 1;
                        break;
                    }
                }
                if(flag2 == 0)
                {
                    matrix[row].push_back(nums[i]);
                    flag1 = 1;
                    break;
                }
            }
            if(flag1 == 0)
            {
                matrix.push_back(vector<int> ());
                matrix[index].push_back(nums[i]);
                index++;
            }
        }
        return matrix;
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
    vector<int> nums = {1,3,4,1,2,3,1};
    Solution S;

    S.show_2d_vector(S.findMatrix(nums));

    return 0;
}