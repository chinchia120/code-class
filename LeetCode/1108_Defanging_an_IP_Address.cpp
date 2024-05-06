#include <iostream>
using namespace std;

class Solution
{
public:
    string defangIPaddr(string address)
    {
        string IPv4 = "";
        for(int i = 0; i < address.length(); i++)
        {
            if(address[i] == '.') IPv4 += "[.]";
            else IPv4 += address[i];
        }
        return IPv4;
    }
};


int main(int argc, char **argv)
{
    string address = "1.1.1.1";
    Solution S;

    cout << S.defangIPaddr(address);

    return 0;
}