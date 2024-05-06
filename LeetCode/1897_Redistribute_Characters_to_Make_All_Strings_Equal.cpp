#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

class Solution
{
public:
    bool makeEqual(vector<string>& words)
    {
        string merge = "";
        for(int i = 0; i < words.size(); i++)
        {
            string word = words[i];
            for(int j = 0; j < word.length(); j++) merge.push_back(word[j]);
        }
        sort(merge.begin(), merge.end());
        
        int cnt = 1;
        char prev = merge[0];
        for(int i = 1; i < merge.length(); i++)
        {
            if(merge[i] == prev) cnt++;
            
            if(merge[i] != prev)
            {   
                if(cnt%words.size() != 0) return false;
                cnt = 1;
                prev = merge[i];
            }
        }
        if(cnt%words.size() != 0) return false;
        else return true;
    }
};

int main(int argc, char **argv)
{
    vector<string> words = {"ab","a"};
    Solution S;

    cout << S.makeEqual(words);

    return 0;
}