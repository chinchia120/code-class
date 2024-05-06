#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution 
{
public:
    bool isValid(string s) 
    {   
        vector<char> data;
        for(int i = 0; i < s.length(); i++)
        {
            if(data.empty() || s[i] == '(' || s[i] == '{' || s[i] == '[') data.push_back(s[i]);
            else if((s[i] == ')' && data.back() == '(') || (s[i] == '}' && data.back() == '{') || (s[i] == ']' && data.back() == '[')) data.pop_back();
            else return false;

            //show_1d_vector(data);
        }
        if(data.empty()) return true;
        else return false;
    }

    void show_1d_vector(vector<char> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = ")";
    Solution S;

    cout << S.isValid(s);

    return 0;
}