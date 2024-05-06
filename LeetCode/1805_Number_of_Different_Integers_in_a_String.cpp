#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int numDifferentIntegers(string word)
    {
        string str = "";
        vector<string> nums;
        for(int i = 0; i < word.length(); i++)
        {
            if(0 <= word[i]-'0' && word[i]-'0' <= 9)
            {
                str.push_back(word[i]);
            }
            else
            {   if(!str.empty())
                {   
                    while(str[0] == '0') str.erase(str.begin());
                    
                    int flag = 0;
                    for(string num: nums)
                    {
                        if(num == str)
                        {
                            flag = 1;
                            break;
                        }
                    }
                    if(flag == 0) nums.push_back(str);
                    str = "";
                }    
            }

            if(i == word.length()-1 && !str.empty())
            {   
                while(str[0] == '0') str.erase(str.begin());
                
                int flag = 0;
                for(string num: nums)
                {
                    if(num == str)
                    {
                        flag = 1;
                        break;
                    }
                }
                if(flag == 0) nums.push_back(str);
            }
        }
        return nums.size();
    }
};

int main(int argc, char **argv)
{
    string word = "a1b01c001";
    Solution S;

    cout << S.numDifferentIntegers(word);

    return 0;
}