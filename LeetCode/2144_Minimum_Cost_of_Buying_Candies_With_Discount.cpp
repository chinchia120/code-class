#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int minimumCost(vector<int>& cost)
    {
        sort(cost.begin(), cost.end());

        int sum = 0, cnt = 0;
        for(int i = cost.size()-1; i >= 0; i--)
        {
            cnt++;
            if(cnt == 3) 
            {
                cnt = 0;
                continue;
            }
            sum += cost[i];
        }
        return sum;
    }
};

int main(int argc, char **argv)
{
    vector<int> cost = {6,5,7,9,2,2};
    Solution S;

    cout << S.minimumCost(cost);

    return 0;
}