#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    int countEven(int num)
    {
        string str = to_string(num);
        if(str.length() == 1) return num/2;
        if(str.length() == 2) return (num%2 == 1)? num/2: (num/10%2 == 0)? num/2: num/2-1;
        if(str.length() == 3) return ((num/100+num/10%10+num%10)%2 == 0)? num/2: (num%2 == 0)? num/2-1: num/2;
        return 499;
    }
};

int main(int argc, char **argv)
{
    int num = 30;
    Solution S;

    cout << S.countEven(num);

    return 0;
}