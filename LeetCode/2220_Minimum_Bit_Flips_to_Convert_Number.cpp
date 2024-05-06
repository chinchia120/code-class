#include <iostream>
using namespace std;

class Solution
{
public:
    int minBitFlips(int start, int goal)
    {
        string Binary1 = Integer2Binary(start), Binary2 = Integer2Binary(goal);
        if(Binary1.length() < Binary2.length())
        {
            string tmp = Binary1;
            Binary1 = Binary2;
            Binary2 = tmp;
        }
        while(Binary1.length() != Binary2.length()) Binary2.insert(Binary2.begin(), '0');
        
        int cnt = 0;
        for(int i = 0; i < Binary1.length(); i++)
        {
            if(Binary1[i] != Binary2[i]) cnt++;
        }
        return cnt;
    }

    string Integer2Binary(int num)
    {
        string Binary = "";
        while(num > 1)
        {   
            Binary.insert(Binary.begin(), num%2+'0');
            num /= 2;
        }
        Binary.insert(Binary.begin(), num+'0');
        return Binary;
    }
};

int main(int argc, char **argv)
{
    int start = 10, goal = 7;
    Solution S;

    cout << S.minBitFlips(start, goal);

    return 0;
}