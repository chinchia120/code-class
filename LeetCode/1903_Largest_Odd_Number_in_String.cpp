#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    string largestOddNumber(string num)
    {   
        int index = -1;
        for(int i = 0; i < num.length(); i++)
        {   
            if((num[num.length()-1-i]-'0')%2 == 1)
            {
                index = num.length()-1-i;
                break;
            }
        }
        
        string odd = "";
        for(int i = 0; i < index+1; i++) odd.push_back(num[i]);

        return odd;
    }
};

int main(int argc, char **argv)
{
    string num = "4206";
    Solution S;

    cout << S.largestOddNumber(num);

    return 0;
}