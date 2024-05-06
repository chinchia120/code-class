#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maximumWealth(vector<vector<int>>& accounts)
    {
        int maxAccount = 0;
        for(vector<int> account: accounts)
        {   
            int sum = 0;
            for(int num: account) sum += num;
            maxAccount = max(maxAccount, sum); 
        }
        return maxAccount;
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> accounts = {{1,2,3},{3,2,1}};
    Solution S;

    cout << S.maximumWealth(accounts);

    return 0;
}