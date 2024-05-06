#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    bool isSumEqual(string firstWord, string secondWord, string targetWord)
    {   
        string num1 = string2number(firstWord), num2 = string2number(secondWord), num3 = string2number(targetWord), sum = "";
        
        if(num1.length() < num2.length())
        {   
            string tmp = num1;
            num1 = num2;
            num2 = tmp;
        }

        while(num1.length() != num2.length()) num2.insert(num2.begin(), '0');

        int prev = 0, carry = 0;
        for(int i = num1.length()-1; i >= 0; i--)
        {   
            if(i >= num2.length()) prev = num1[i]-'0';
            else prev = num1[i]-'0'+num2[i]-'0';

            sum.insert(sum.begin(), ((prev+carry)%10)+'0');
            carry = (prev+carry)/10;
        }
        if(carry != 0) sum.insert(sum.begin(), carry+'0');
        
        while(sum[0] == '0') sum.erase(sum.begin());
        while(num3[0] == '0') num3.erase(num3.begin());

        //cout << sum << " " << num3 << endl;
        return (sum == num3)? true: false;
    }

    string string2number(string str)
    {
        string num = "";
        for(char ch: str) num.push_back((((int)ch) - 97) + '0');
        return num;
    }
};

int main(int argc, char **argv)
{
    string firstWord = "a", secondWord = "aaa", targetWord = "aaaa";
    Solution S;

    cout << S.isSumEqual(firstWord, secondWord, targetWord);

    return 0;
}