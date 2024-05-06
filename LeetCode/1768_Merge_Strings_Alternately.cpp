#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    string mergeAlternately(string word1, string word2)
    {
        string str = "";
        while(word1.length() != 0 || word2.length() != 0)
        {
            if(word1.length() != 0)
            {
                str.push_back(word1[0]);
                word1.erase(word1.begin());
            }

            if(word2.length() != 0)
            {
                str.push_back(word2[0]);
                word2.erase(word2.begin());
            }
        }
        return str;
    }
};

int main(int argc, char **argv)
{
    string word1 = "ab", word2 = "pqrs";
    Solution S;

    cout << S.mergeAlternately(word1, word2);

    return 0;
}