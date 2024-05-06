#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<string> divideString(string s, int k, char fill)
    {
        vector<string> spt;
        for(int i = 0; i < s.length()-s.length()%k; i+=k)
        {
            string tmp = "";
            for(int j = 0; j < k; j++) tmp.push_back(s[i+j]);
            spt.push_back(tmp);
        }

        if(s.length()%k != 0)
        {   
            string tmp;
            for(int i = s.length()-s.length()%k; i < s.length(); i++) tmp.push_back(s[i]);
            for(int i = 0; i < k-s.length()%k; i++) tmp.push_back(fill);
            spt.push_back(tmp);
        }
        return spt;
    }

    void show_1d_vector(vector<string> vec)
    {
        for(string str: vec) cout << str << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "abcdefghij";
    int k = 3;
    char fill = 'x';
    Solution S;

    S.show_1d_vector(S.divideString(s, k, fill));

    return 0;
}