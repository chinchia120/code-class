#include <iostream>
using namespace std;

class Solution
{
public:
    int countDigits(int num)
    {
        int _num = num, cnt = 0;
        while(num != 0)
        {
            if(_num%(num%10) == 0) cnt++;
            num /= 10;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    int num = 1248;
    Solution S;

    cout << S.countDigits(num);

    return 0;
}