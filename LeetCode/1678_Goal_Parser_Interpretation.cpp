#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    string interpret(string command)
    {
        string str = "";
        for(int i = 0; i < command.length(); i++)
        {
            if(command[i] == '(' && command[i+1] == ')')
            {
                str.push_back('o');
                i += 1;
            }
            else if(command[i] == '(' && command[i+1] == 'a')
            {
                str.push_back('a');
                str.push_back('l');
                i += 3;
            }
            else str.push_back(command[i]);
        }
        return str;
    }
};

int main(int argc, char **argv)
{
    string command = "(al)G(al)()()G";
    Solution S;

    cout << S.interpret(command);

    return 0;
}