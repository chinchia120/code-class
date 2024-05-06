#include <iostream>
using namespace std;

class Solution
{
public:
    bool isThree(int n)
    {
        if(n <= 3) return false;

        int cnt = 0;
        for(int i = 1; i <= n; i++)
        {
            if(n%i == 0) cnt++;
            if(cnt == 4) return false;
        }
        return (cnt == 3)? true: false;
    }
};

int main(int argc, char **argv)
{
    int n = 4;
    Solution S;

    cout << S.isThree(n);

    return 0;
}