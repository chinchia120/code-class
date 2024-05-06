#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

class Solution
{
public:
    string gcdOfStrings(string str1, string str2)
    {
        if(str1+str2 == str2+str1) return str1.substr(0, __gcd(str1.size(), str2.size()));
        else return "";
    }
};

int main(int argc, char **argv)
{
    string str1 = "ABCABC", str2 = "ABC";
    Solution S;

    cout << S.gcdOfStrings(str1, str2);

    return 0;
}