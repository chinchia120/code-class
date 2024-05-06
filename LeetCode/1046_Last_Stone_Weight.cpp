#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int lastStoneWeight(vector<int>& stones)
    {   
        if(stones.size() == 1) return stones[0];
        if(stones.size() == 2) return abs(stones[0]-stones[1]);
        
        sort(stones.begin(), stones.end());
        while(stones.size() != 1)
        {
            int tmp = abs(stones[stones.size()-1] - stones[stones.size()-2]);
            stones.pop_back();
            stones.pop_back();
            stones.push_back(tmp);

            sort(stones.begin(), stones.end());
        }
        return stones[0];
    }
};

int main(int argc, char **argv)
{
    vector<int> stones = {2,7,4,1,8,1};
    Solution S;

    cout << S.lastStoneWeight(stones);

    return 0;
}