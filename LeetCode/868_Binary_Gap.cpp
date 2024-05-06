#include <iostream>
using namespace std;

class Solution
{
public:
    int binaryGap(int n)
    {
        string num = "";
        while(n > 1)
        {
            num.insert(num.begin(), n%2+'0');
            n /= 2;
            if(n < 2)
            {
                num.insert(num.begin(), n+'0');
            }  
        }
        cout << num << endl;

        int max = 0, index = 0;
        for(int i = 1; i < num.length(); i++)
        {
            if(num[i] == '1')
            {
                if(i-index > max) max = i-index;
                index = i;
            }
        }
        return max;
    }
};

int main(int argc, char **argv)
{
    int n = 5;
    Solution S;

    cout << S.binaryGap(n);

    return 0;
}