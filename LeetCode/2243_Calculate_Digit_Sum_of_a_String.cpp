#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    string digitSum(string s, int k)
    {
        while(s.length() > k)
        {
            vector<string> spt = SplitString(s, k);
            s.clear();
            for(string str: spt)
            {   
                int sum = 0;
                for(char ch: str) sum += ch-'0';
                
                string tmp = to_string(sum);
                for(char ch: tmp) s.push_back(ch);
            }
        }
        return s;
    }

    vector<string> SplitString(string str, int k)
    {   
        vector<string> spt;
        string tmp = "";
        for(int i = 0; i < str.length(); i++)
        {   
            if(i%k == 0 && !tmp.empty())
            {
                spt.push_back(tmp);
                tmp = "";
            }
            tmp.push_back(str[i]);
        }
        if(!tmp.empty()) spt.push_back(tmp);
        
        return spt;
    }

    void Show1DVector(vector<string> vec)
    {
        for(string num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "11111222223";
    int k = 3;
    Solution S;

    cout << S.digitSum(s, k);

    return 0;
}