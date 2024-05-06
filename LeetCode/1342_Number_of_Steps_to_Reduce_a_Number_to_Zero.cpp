#include <iostream>
using namespace std;

class Solution
{
public:
    int numberOfSteps(int num)
    {   
        int cnt = 0;
        while(num != 0)
        {
            if(num%2 == 0) num /= 2;
            else num -= 1;
            cnt++;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    int num = 14;
    Solution S;

    cout << S.numberOfSteps(num);

    return 0;
}