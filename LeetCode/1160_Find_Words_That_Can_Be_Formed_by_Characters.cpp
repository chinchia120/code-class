#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countCharacters(vector<string>& words, string chars)
    {
        int sum = 0;
        for(int i = 0; i < words.size(); i++)
        {
            string word = words[i];
            string chars_copy = chars;
            int flag1 = 1;
            for(int j = 0; j < word.length(); j++)
            {
                int flag2 = 0;
                for(int k = 0; k < chars_copy.length(); k++)
                {
                    if(word[j] == chars_copy[k])
                    {
                        flag2 = 1;
                        chars_copy.erase(chars_copy.begin()+k);
                        break;
                    }
                }
                if(flag2 == 0)
                {
                    flag1 = 0;
                    break;
                }
            }
            if(flag1 == 1) sum += word.length();
        }
        return sum;
    }
};

int main(int argc, char **argv)
{
    vector<string> words = {"cat","bt","hat","tree"}; 
    string chars = "atach";
    Solution S;

    cout << S.countCharacters(words, chars);

    return 0;
}