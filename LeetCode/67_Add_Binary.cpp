#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

class Solution 
{
public:
    string addBinary(string a, string b) 
    {   
        reverse(a.begin(), a.end());
        reverse(b.begin(), b.end());

        string sum = "";
        int carry = 0; 
        for(int i = 0; i < max(a.length(), b.length()); i++)
        {   
            if(i >= a.length()) a.push_back('0');
            if(i >= b.length()) b.push_back('0');

            int tmp = a[i]-'0'+b[i]-'0'+carry;
            sum.insert(sum.begin()+0,  (tmp%2)+'0');
            carry = tmp/2;
        }
        if(carry == 1) sum.insert(sum.begin()+0, '1');

        return sum;
    }
};

int main(int argc, char **argv)
{
    string a = "1010", b = "1011";
    Solution S;

    cout << S.addBinary(a, b);

    return 0;
}