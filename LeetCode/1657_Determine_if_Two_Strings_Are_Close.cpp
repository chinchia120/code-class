#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    bool closeStrings(string word1, string word2)
    {
        if(word1.length() != word2.length()) return false;

        sort(word1.begin(), word1.end());
        sort(word2.begin(), word2.end());

        vector<int> ch1 = {(int)word1[0]}, ch2 = {(int)word2[0]};
        vector<int> cnt1, cnt2;
        char prev = word1[0];
        int cnt = 1;
        for(int i = 1; i < word1.length(); i++)
        {
            if(prev == word1[i]) cnt++;
            else
            {
                cnt1.push_back(cnt);
                ch1.push_back((int)word1[i]);
                cnt = 1;
                prev = word1[i];
            }

            if(i == word1.length()-1)
            {   
                if(prev != word1[i]) ch1.push_back((int)word1[i]);
                cnt1.push_back(cnt);
                prev = word2[0];
                cnt = 1;
            }
        }
        //show_1d_vector(cnt1);
        //show_1d_vector(ch1);

        for(int i = 1; i < word2.length(); i++)
        {
            if(prev == word2[i]) cnt++;
            else
            {
                cnt2.push_back(cnt);
                ch2.push_back((int)word2[i]);
                cnt = 1;
                prev = word2[i];
            }

            if(i == word2.length()-1)
            {   
                cnt2.push_back(cnt);
                if(prev != word2[i]) ch2.push_back((int)word2[i]);
            }
        }
        //show_1d_vector(cnt2);
        //show_1d_vector(ch2);

        if(cnt1.size() != cnt2.size()) return false;
        sort(ch1.begin(), ch1.end());
        sort(ch2.begin(), ch2.end());
        for(int i = 0; i < ch1.size(); i++)
        {
            if(ch1[i] != ch2[i]) return false;
        }

        sort(cnt1.begin(), cnt1.end());
        sort(cnt2.begin(), cnt2.end());
        for(int i = 0; i < cnt1.size(); i++)
        {
            if(cnt1[i] != cnt2[i]) return false;
        }
        return true;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string word1 = "mkmczky", word2 = "cckcmmy";
    Solution S;

    cout << S.closeStrings(word1, word2);

    return 0;
}