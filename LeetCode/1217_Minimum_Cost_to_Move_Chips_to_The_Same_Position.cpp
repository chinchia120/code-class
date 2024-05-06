#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minCostToMoveChips(vector<int>& position)
    {   
        int even = 0, odd = 0;
        for(int pos: position)
        {
            if(pos%2 == 0) even++;
            if(pos%2 != 0) odd++;
        }
        return min(even, odd);
    }
};

int main(int argc, char **argv)
{
    vector<int> position = {2,2,2,3,3};
    Solution S;

    cout << S.minCostToMoveChips(position);

    return 0;
}