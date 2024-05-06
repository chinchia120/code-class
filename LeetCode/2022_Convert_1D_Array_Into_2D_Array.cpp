#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> construct2DArray(vector<int>& original, int m, int n)
    {
        vector<vector<int>> arr;
        if(original.size() != m*n) return arr;

        int index = 0;
        for(int i = 0; i < m; i++)
        {
            for(int j = 0; j < n; j++)
            {
                if(j == 0) arr.push_back(vector<int> ());
                arr[i].push_back(original[index]);
                index++;
            }
        }
        return arr;
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
    vector<int> original = {1,2,3,4};
    int m = 2, n = 2;
    Solution S;

    S.show_2d_vector(S.construct2DArray(original, m, n));

    return 0;
}