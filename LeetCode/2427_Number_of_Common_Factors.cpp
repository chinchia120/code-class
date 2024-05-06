#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int commonFactors(int a, int b) 
    {
        int _gcd = gcd(a, b), cnt = 0;
        for(int i = 1; i <= _gcd; i++) if(_gcd%i == 0) cnt++;
        return cnt;
    }
};