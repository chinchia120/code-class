#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int numRollsToTarget(int n, int k, int target)
    {
        if(n*k < target) return 0;
        
        int cont = 1e9+7;
        vector<vector<int>> dp(n+1, vector<int> (target+1));
        dp[0][0] = 1;
        for(int i = 1; i <= n; i++)
        {
            for(int j = 1; j <= k; j++)
            {
                for(int l = j; l <= target; l++)
                {
                    dp[i][l] = (dp[i][l] + dp[i-1][l-j]) % cont;
                }
            }
        }
        //show_2d_vector(dp);
        return dp[n][target];
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
    int n = 3, k = 6, target = 7;
    Solution S;

    cout << S.numRollsToTarget(n, k, target);

    return 0;
}
