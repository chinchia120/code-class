#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int vowelStrings(vector<string>& words, int left, int right)
    {
        int cnt = 0;
        for(int i = left; i <= right; i++)
        {
            string word = words[i];
            if((word[0] == 'a' || word[0] == 'e' || word[0] == 'i' || word[0] == 'o' || word[0] == 'u') && (word.back() == 'a' || word.back() == 'e' || word.back() == 'i' || word.back() == 'o' || word.back() == 'u')) cnt++;
        }
        return cnt;
    }
};