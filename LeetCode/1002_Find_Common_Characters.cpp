#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<string> commonChars(vector<string>& words)
    {   
        vector<string> word;
        string check = words[0];
        for(int i = 0; i < check.length(); i++)
        {   
            int flag = 0;
            for(int j = 1; j < words.size(); j++)
            {
                string tmp = words[j];
                for(int k = 0; k < tmp.length(); k++)
                {
                    if(check[i] == tmp[k])
                    {
                        tmp.erase(tmp.begin()+k);
                        flag = 1;
                        break;
                    }
                }
                words[j] = tmp;
                if(flag == 0) break;
                else if(flag == 1 && j != words.size()-1) flag = 0;
            }
            string str = "";
            str.push_back(check[i]);
            if(flag == 1) word.push_back(str);
        }
        return word;
    }

    void show_1d_vector(vector<string> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<string> words= {"bella","label","roller"};
    //vector<string> words = {"qewrtetwqerrtetwqrtrtt","z"};
    Solution S;

    S.show_1d_vector(S.commonChars(words));
}