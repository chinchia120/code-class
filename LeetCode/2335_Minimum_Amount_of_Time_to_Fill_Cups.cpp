#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int fillCups(vector<int>& amount)
    {   
        int cnt = 0;
        while(amount[0] > 0 || amount[1] > 0 || amount[2] > 0)
        {   
            cnt++;
            if(amount[0] <= amount[1] && amount[0] <= amount[2])
            {
                amount[1]--;
                amount[2]--;
            }
            else if(amount[1] <= amount[0] && amount[1] <= amount[2])
            {
                amount[0]--;
                amount[2]--;
            }
            else if(amount[2] <= amount[0] && amount[2] <= amount[1])
            {
                amount[0]--;
                amount[1]--;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<int> amount = {5,0,0};
    Solution S;

    cout << S.fillCups(amount);

    return 0;
}