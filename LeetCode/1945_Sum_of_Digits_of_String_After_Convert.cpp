#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    int getLucky(string s, int k)
    {
        string str = "";
        for(char ch: s)
        {
            string num =  to_string((int)ch-96);
            for(char tmp: num) str.push_back(tmp);
        }
        
        
        for(int i = 0; i < k; i++)
        {   
            int tmp = 0;
            for(char ch: str) tmp += ch-'0';
            
            if(i != k-1) str = to_string(tmp);
            else return tmp;
        }
        return 0;
    }
};

int main(int argc, char **argv)
{
    string s = "leetcode";
    int k = 2;
    Solution S;

    cout << S.getLucky(s, k);

    return 0; 
}