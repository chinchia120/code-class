#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    int numOfStrings(vector<string>& patterns, string word)
    {
        int cnt = 0;
        for(string pattern: patterns)
        {   
            int flag = 0;
            for(int i = 0; i < word.length(); i++)
            {
                if(pattern[0] == word[i])
                {   
                    int len = i+pattern.length();
                    if(len <= word.length() && pattern == word.substr(i, pattern.length()))
                    {
                        flag = 1;
                        break;
                    }
                }
            }
            if(flag == 1) cnt++;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{   
    /*
    vector<string> patterns = {"a","abc","bc","d"};
    string word = "abc";
    */
    vector<string> patterns = {"dojsf","v","hetnovaoigv","ksvqfdojsf","hetnovaoig","yskjs","sfr","msurztkvppptsluk","ndxffbkkvejuakduhdcfsdbgbt","znhdgtwzbnh","h","ocaualfiscmbpnfalypmtdppymw","w","o","sfjksvqfdo","odqvzuc","bozawheajcmlewptgssueylcxhx","bno","jhmarzsphxduvdktzqjiz","j","sfrjhetnov","vxv","ksvqfd","ognwvqtadalmav","yqbspvfwmvhycmghabigl","qyfaiazgdqaw","ojsfrj","ojsfrjhetn","fdojs","do","ovaoig","k","vrh","jsfrjhetnovaoigvgk"};
    string word = "csfjksvqfdojsfrjhetnovaoigvgk";
    Solution S;

    cout << S.numOfStrings(patterns, word);

    return 0;
}