#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int buyChoco(vector<int>& prices, int money)
    {
        sort(prices.begin(), prices.end());
        if(money >= prices[0]+prices[1]) return money-prices[0]-prices[1];
        return money;
    }
};

int main(int argc, char **argv)
{
    vector<int> prices = {3,2,3};
    int money = 3;
    Solution S;

    cout << S.buyChoco(prices, money);

    return 0;

}