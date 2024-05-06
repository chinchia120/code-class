#include <iostream>
#include <string>
#include <cmath>
using namespace std;

class Solution
{
public:
    int bitwiseComplement(int n)
    {
        string num;
        while(n > 1)
        {
            int mod = n % 2;
            if(mod == 1) num.insert(num.begin(), '0');
            else num.insert(num.begin(), '1');
            n /= 2;
        }
        if(n == 1) num.insert(num.begin(), '0');
        else num.insert(num.begin(), '1');

        int sum = 0;
        for(int i = 0; i < num.length(); i++)
        {
            if(num[i] == '1') sum += pow(2, num.length()-1-i);
        }
        return sum;
    }
};

int main(int argc, char **argv)
{
    int n = 5;
    Solution S;

    cout << S.bitwiseComplement(n);

    return 0;
}