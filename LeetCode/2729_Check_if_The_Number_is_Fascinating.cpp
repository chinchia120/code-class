#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution
{
public:
    bool isFascinating(int n)
    {
        //OutputFascinating();
        return (n == 192 || n == 219 || n == 273 || n == 327)? true: false;
    }

    void OutputFascinating()
    {
        for(int i = 100; i < 1000; i++)
        {
            string str = to_string(i)+to_string(i*2)+to_string(i*3);
            
            vector<char> NumLists;
            int flag1 = 1;
            for(char ch: str)
            {   
                if(ch == '0')
                {
                    flag1 = 0;
                    break;
                }

                int flag2 = 0;
                for(char NumList: NumLists)
                {
                    if(ch == NumList)
                    {
                        flag2 = 1;
                        break;
                    }
                }
                
                if(flag2 == 0) NumLists.push_back(ch);
                if(flag2 == 1)
                {
                    flag1 = 0;
                    break;
                }
            }
            if(flag1 == 1) cout << i << " ";
        }
    }
};

int main(int argc, char **argv)
{
    int n = 192;
    Solution S;

    cout << S.isFascinating(n);

    return 0;
}