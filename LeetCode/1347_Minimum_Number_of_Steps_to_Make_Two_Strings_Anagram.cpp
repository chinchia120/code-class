#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minSteps(string s, string t)
    {
        vector<int> cnt_s = count_character(s), cnt_t = count_character(t);
        
        int cnt = 0;
        for(int i = 0; i < 26; i++) cnt += abs(cnt_s[i]-cnt_t[i]);
        return cnt/2;
    }

    vector<int> count_character(string s)
    {
        vector<int> vec (26, 0);
        for(char ch: s) vec[(int)ch-97]++;
        return vec;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "bab", t = "aba";
    Solution S;

    cout << S.minSteps(s, t);

    return 0;
}