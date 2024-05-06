#include <iostream>
using namespace std;

class Solution
{
public:
    int distinctIntegers(int n)
    {
        return (n == 1)? 1: n-1;
    }
};