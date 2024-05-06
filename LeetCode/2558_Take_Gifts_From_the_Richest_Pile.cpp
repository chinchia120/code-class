#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>
using namespace std;

class Solution
{
public:
    long long pickGifts(vector<int>& gifts, int k)
    {
        for(int i = 0; i < k; i++)
        {
            sort(gifts.begin(), gifts.end());
            gifts[gifts.size()-1] = (int)sqrt(gifts.back());
        }

        long long int sum = 0;
        for(int gift: gifts) sum += gift;
        return sum;
    }
};

int main(int argc, char **argv)
{
    vector<int> gifts = {25,64,9,4,100};
    int k = 4;
    Solution S;

    cout << S.pickGifts(gifts, k);

    return 0;
}