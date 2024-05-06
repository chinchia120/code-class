#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    int maximumValue(vector<string>& strs)
    {
        int MaxValue = 0;
        for(string str: strs)
        {   
            int flag = 0;
            for(char ch: str)
            {
                if(islower(ch))
                {
                    flag = 1;
                    break;
                }
            }

            if(flag == 0) MaxValue = max(MaxValue, stoi(str));
            if(flag == 1) MaxValue = max(MaxValue, (int)str.length());
        }
        return MaxValue;
    }
};

int main(int argc, char **argv)
{
    vector<string> strs = {"alic3","bob","3","4","00000"};
    Solution S;

    cout << S.maximumValue(strs);

    return 0;
}