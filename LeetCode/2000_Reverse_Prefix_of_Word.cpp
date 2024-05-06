#include <iostream>
using namespace std;

class Solution
{
public:
    string reversePrefix(string word, char ch)
    {
        string str = "";
        int flag = 0;
        for(char tmp: word)
        {   
            if(flag == 0 && tmp != ch)
            {
                str.insert(str.begin(), tmp);
            }
            else if(flag == 0 && tmp == ch)
            {
                flag = 1;
                str.insert(str.begin(), tmp);
            }
            else
            {
                str.push_back(tmp);
            }
        }
        return (flag == 1)? str: word;
    }
};

int main(int argc, char **argv)
{
    string word = "abcdefd";
    char ch = 'd';
    Solution S;

    cout << S.reversePrefix(word, ch);

    return 0;
}