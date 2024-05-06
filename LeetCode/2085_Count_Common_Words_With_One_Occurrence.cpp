#include <iostream>
#include <vector>
#include <map>
using namespace std;

class Solution
{
public:
    struct Word
    {
        string word;
        int fre1;
        int fre2;
    };

    int countWords(vector<string>& words1, vector<string>& words2)
    {
        map<string, Word> wordMap;
        for(string word: words1)
        {   
            int flag = 0;
            for(const auto& map: wordMap)
            {
                if(map.second.word == word)
                {   
                    flag = 1;
                    wordMap[word] = {word, map.second.fre1+1, map.second.fre2};
                    break;
                }
            }
            if(flag == 0) wordMap[word] = {word, 1, 0};
        }

        for(string word: words2)
        {   
            int flag = 0;
            for(const auto& map: wordMap)
            {
                if(map.second.word == word)
                {   
                    flag = 1;
                    wordMap[word] = {word, map.second.fre1, map.second.fre2+1};
                    break;
                }
            }
            if(flag == 0) wordMap[word] = {word, 0, 1};
        }
        //show_map(wordMap);

        int cnt = 0;
        for(const auto& map: wordMap)
        {
            if(map.second.fre1 == 1 && map.second.fre2 == 1) cnt++;
        }
        return cnt;
    }

    void show_map(map<string, Word> wordMap)
    {
        for(const auto& word: wordMap) 
        {
            cout << word.second.word << " " << word.second.fre1 << " " << word.second.fre2 << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<string> word1 = {"leetcode","is","amazing","as","is"};
    vector<string> word2 = {"amazing","leetcode","is"};
    Solution S;

    cout << S.countWords(word1, word2);

    return 0;
}