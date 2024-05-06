#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    int countVowelSubstrings(string word)
    {   
        if(word.length() < 5) return 0;

        int cnt = 0;
        for(int i = 0; i < word.length()-4; i++)
        {   
            for(int j = 5; j <= word.length()-i; j++)
            {
                string tmp = word.substr(i, j);
                if(!CheckOnlyVowel(tmp)) break;

                if(!CheckVowel(tmp, 'a')) continue;
                if(!CheckVowel(tmp, 'e')) continue;
                if(!CheckVowel(tmp, 'i')) continue;
                if(!CheckVowel(tmp, 'o')) continue;
                if(!CheckVowel(tmp, 'u')) continue;
                
                cnt++;
            }
        }
        return cnt;
    }

    bool CheckVowel(string str, char vowel)
    {
        for(char ch: str) if(ch == vowel) return true;
        return false;
    }

    bool CheckOnlyVowel(string str)
    {
        for(char ch: str) if(ch != 'a' && ch != 'e' && ch != 'i' && ch != 'o' && ch != 'u') return false;
        return true;
    }
};

int main(int argc, char **argv)
{
    string word = "poazaeuioauoiioaouuouaui";
    Solution S;

    cout << S.countVowelSubstrings(word);

    return 0;
}