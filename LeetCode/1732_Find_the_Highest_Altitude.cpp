#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int largestAltitude(vector<int>& gain)
    {
        int altitude = 0, maxAlt = 0;
        for(int num: gain)
        {
            altitude += num;
            maxAlt = max(maxAlt, altitude);
        }
        return maxAlt;
    }
};

int main(int argc, char **argv)
{
    vector<int> gain = {-4,-3,-2,-1,4,3,2};
    Solution S;

    cout << S.largestAltitude(gain);

    return 0;
}