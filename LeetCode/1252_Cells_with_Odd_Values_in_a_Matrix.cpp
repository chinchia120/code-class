#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int oddCells(int m, int n, vector<vector<int>>& indices)
    {   
        int cnt = 0;
        for(int i = 0; i < m; i++)
        {   
            for(int j = 0; j < n; j++)
            {   
                int sum = 0;
                for(int k = 0; k < indices.size(); k++)
                {
                    if(indices[k][0] == i) sum++;
                    if(indices[k][1] == j) sum++;
                }
                if(sum%2 == 1) cnt++;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    int m = 2, n = 3;
    vector<vector<int>> indices = {{0, 1}, {1, 1}};
    Solution S;

    cout << S.oddCells(m, n, indices);

    return 0;
}