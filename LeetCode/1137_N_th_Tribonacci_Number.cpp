#include <iostream>
using namespace std;

class Solution
{
public:
    int tribonacci(int n)
    {   
        if(n < 2) return n;

        int first = 0, second = 1, third = 1;
        for(int i = 2; i < n; i++)
        {
            int tmp = first;
            first = second;
            second = third;
            third = tmp + first + second;
        }
        return third;
    }
};

int main(int argc, char **argv)
{
    int n = 35;
    Solution S;

    cout << S.tribonacci(n);

    return 0;
}