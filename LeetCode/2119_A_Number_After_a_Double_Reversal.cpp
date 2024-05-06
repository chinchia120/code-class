#include <iostream>
#include <algorithm>
using namespace std;

class Solution
{
public:
    bool isSameAfterReversals(int num)
    {   
        string str = to_string(num);
        reverse(str.begin(), str.end());
         
        return (str.size() != 1 && str[0] == '0')? false: true;
    }
};

int main(int argc, char **argv)
{
    int num = 1800;
    Solution S;

    cout << S.isSameAfterReversals(num);

    return 0;
}