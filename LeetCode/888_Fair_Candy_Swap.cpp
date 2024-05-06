#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> fairCandySwap(vector<int>& aliceSizes, vector<int>& bobSizes)
    {
        for(int i = 0; i < aliceSizes.size(); i++)
        {
            for(int j = 0; j < bobSizes.size(); j++)
            {
                
            }
        }
    }
};

int main(int argc, char **argv)
{
    vector<int> aliceSizes = {1, 1}, bobSizes = {2, 2};
    Solution S;

    cout << S.fairCandySwap(aliceSizes, bobSizes);

    return 0;
}