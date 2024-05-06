#include <iostream>
using namespace std;

class Solution
{
public:
    int rangeBitwiseAnd(int left, int right)
    {   
        int num = right;
        for(int i = left; i < right; i++)
        {
            int tmp = num&i;
        }
        return num;
    }
};

int main(int argc, char **argv)
{
    int left = 2, right = 6;
    Solution S;

    cout << S.rangeBitwiseAnd(left, right);

    return 0;
}