#include <iostream>
using namespace std;

class Solution
{
public:
    int passThePillow(int n, int time)
    {   
        int check = (time+1)%(2*n-2);
        return (check == 0)? 2: (check < n)? check: 2*n-check;
    }
};