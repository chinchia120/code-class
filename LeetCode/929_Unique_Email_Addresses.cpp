#include <iostream>
#include <vector>
#include <unordered_set>
using namespace std;

class Solution
{
public:
    int numUniqueEmails(vector<string>& emails)
    {
        vector<string> local, domain;
        for(int i = 0; i < emails.size(); i++)
        {
            vector<string> tmp;
            tmp = split_string(emails[i], tmp);
            local.push_back(tmp[0]);
            domain.push_back(tmp[1]);
        }

        for(int i = 0; i < local.size(); i++)
        {   
            string temp = "", str = local[i];
            for(int j = 0; j < str.length(); j++)
            {
                if(str[j] == '.') continue;
                else if(str[j] == '+') break;
                else temp.push_back(str[j]);
            }

            if(!temp.empty()) local[i] = temp;
            
            string str2 = domain[i];
            local[i].push_back('@');
            for(int j = 0; j < str2.length(); j++)
            {
                local[i].push_back(str2[j]);
            }
        }
        //show_1d_vector(local);

        unordered_set<string> set(local.begin(), local.end());

        return set.size();
    }
    
    vector<string> split_string(string str, vector<string> vec)
    {   
        string tmp = "";
        for(int i = 0; i < str.length(); i++)
        {
            if((str[i] == '@' && !tmp.empty()))
            {
                vec.push_back(tmp);
                tmp = "";
            }
            else tmp.push_back(str[i]);
        }
        if(!tmp.empty()) vec.push_back(tmp);

        return vec;
    }

    void show_1d_vector(vector<string> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<string> emails = {"test.email+alex@leetcode.com","test.e.mail+bob.cathy@leetcode.com","testemail+david@lee.tcode.com"};
    Solution S;

    cout << S.numUniqueEmails(emails);

    return 0;
}