#include <iostream>
using namespace std;

class Solution
{
public:
    bool checkOnesSegment(string s)
    {
        int flag = 2;
        for(char ch: s)
        {
            if(flag == 2 && ch == '0') flag = 1;
            if(flag == 1 && ch == '1')
            {
                flag = 0;
                break;
            }
        }
        if(flag == 2 || flag == 1) return true;
        else return false;
    }
};

int main(int argc, char **argv)
{
    string s = "1001";
    Solution S;

    cout << S.checkOnesSegment(s);

    return 0;
}