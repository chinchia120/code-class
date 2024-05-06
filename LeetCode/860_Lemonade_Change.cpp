#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool lemonadeChange(vector<int>& bills)
    {   
        int five = 0, ten = 0;
        for(int i = 0; i < bills.size(); i++)
        {
            if(bills[i] == 5)
            {
                five++;
            }

            if(bills[i] == 10)
            {
                five--;
                ten++;
            }

            if(bills[i] == 20)
            {   
                if(ten > 0)
                {
                    ten--;
                    five--;
                }
                else if(ten == 0)
                {
                    five -= 3;
                }
            }
            //cout << five << " " << ten << endl;
            if(five < 0 || ten < 0) return false;
        }
        return true;
    }
};

int main(int argc, char **argv)
{
    vector<int> bills = {5,5,5,10,5,5,10,20,20,20};
    Solution S;

    cout << S.lemonadeChange(bills);

    return 0;
}