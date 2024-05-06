#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    int largestInteger(int num)
    {
        string str = to_string(num);
        for(int i = 0; i < str.length(); i++)
        {
            for(int j = i+1; j < str.length(); j++)
            {
                if(str[i]-'0' < str[j]-'0' && (str[i]-'0')%2 == (str[j]-'0')%2)
                {
                    char tmp = str[i];
                    str[i] = str[j];
                    str[j] = tmp;
                }
            }
        }
        //cout << str << endl;
        return stoi(str);
    }
};

int main(int argc, char **argv)
{
    int num = 1234;
    Solution S;

    cout << S.largestInteger(num);

    return 0;
}