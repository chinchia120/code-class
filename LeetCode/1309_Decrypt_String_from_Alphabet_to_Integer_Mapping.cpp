#include <iostream>
#include <vector>

using namespace std;

class Solution
{
public:
    string freqAlphabets(string s)
    {
        vector<string> str;
        for(int i = 0; i < s.length(); i++)
        {      
            string tmp = "";
            tmp.push_back(s[i]);

            if(tmp == "#")
            {
                tmp.pop_back();
                tmp.push_back(s[i-2]);
                tmp.push_back(s[i-1]);
                str.pop_back();
                str.pop_back();
            }
            str.push_back(tmp);
        }
        //show_1d_vector(str);

        string decrypt_string = "";
        for(int i = 0; i < str.size(); i++)
        {
            decrypt_string.push_back((char)(stoi(str[i])+96));
        }
        return decrypt_string;
    }

    void show_1d_vector(vector<string> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "10#11#12";
    Solution S;

    cout << S.freqAlphabets(s);

    return 0;
}