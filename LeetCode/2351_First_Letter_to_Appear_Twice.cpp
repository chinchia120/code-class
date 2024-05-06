#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    char repeatedCharacter(string s)
    {
        vector<char> letters;
        for(char ch: s)
        {
            for(char letter: letters)
            {
                if(ch == letter) return ch;
            }
            letters.push_back(ch);
        }
        return 'a';
    }
};

int main(int argc, char **argv)
{
    string s = "abccbaacz";
    Solution S;

    cout << S.repeatedCharacter(s);

    return 0;
}