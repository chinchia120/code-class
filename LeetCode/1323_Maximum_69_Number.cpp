#include <iostream>
#include <string>
using namespace std;

class Solution {
public:
    int maximum69Number (int num)
    {
        string str = to_string(num);
        for(int i = 0; i < str.length(); i++)
        {
            if(str[i] == '6')
            {
                str[i] = '9';
                break;
            }
        }
        return stoi(str);
    }
};

int main(int argc, char **argv)
{
    int num = 9669;
    Solution S;

    cout << S.maximum69Number(num);

    return 0;
}