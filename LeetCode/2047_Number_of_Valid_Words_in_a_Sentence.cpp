#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countValidWords(string sentence)
    {
        vector<string> spt = split_string(sentence);
        //show_1d_vector(spt);

        int cnt = 0;
        for(string str: spt)
        {   
            int flag = 1, hyphen = 0;
            for(int i = 0; i < str.length(); i++)
            {
                if(str[i] == '-') hyphen++;
                if(hyphen == 2)
                {
                    flag = 0;
                    break;
                }

                if(!(97 <= (int)str[i] && (int)str[i] <= 122) && str[i] != '-' && i != str.length()-1)
                {
                    flag = 0;
                    break;
                }

                if(48 <= (int)str[i] && (int)str[i] <= 57 || str.back() == '-' || str[0] == '-') flag = 0;
                if(str.length() == 1 && str[i] == '-') flag = 0;
                if(str.length() != 1 && str[str.length()-2] == '-' && (!(97 <= (int)str.back() && (int)str.back() <= 122))) flag = 0;
            }
            if(flag == 1)
            {
                cnt++;
                cout << str << " ";
            }
        }
        return cnt;
    }

    vector<string> split_string(string str)
    {
        string tmp = "";
        vector<string> spt;
        for(char ch: str)
        {
            if(ch != ' ') tmp.push_back(ch);
            else if(!tmp.empty() && ch == ' ')
            {
                spt.push_back(tmp);
                tmp = "";
            }
        }
        if(!tmp.empty()) spt.push_back(tmp);
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
    string sentence = ". ! 7hk  al6 l! aon49esj35la k3 7u2tkh  7i9y5  !jyylhppd et v- h!ogsouv 5";
    Solution S;

    cout << S.countValidWords(sentence);

    return 0;
}