#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    bool strongPasswordCheckerII(string password)
    {
        if(password.length() < 8) return false;

        string special_character = "!@#$%^&*()-+";
        int lowercase = 0, uppercase = 0, digit = 0, special = 0;
        for(int i = 0; i < password.length(); i++)
        {   
            if(i != 0)
            {
                if(password[i-1] == password[i]) return false;
            }

            if(lowercase == 0 && islower(password[i]))
            {
                lowercase = 1;
                continue;
            }

            if(uppercase == 0 && isupper(password[i]))
            {
                uppercase = 1;
                continue;
            }

            if(digit == 0 && (48 <= (int)password[i] && (int)password[i] <= 57))
            {
                digit = 1;
                continue;
            }

            if(special == 0)
            {
                for(char ch: special_character)
                {
                    if(ch == password[i])
                    {
                        special = 1;
                        continue;
                    }
                }
            }
        }
        return (lowercase == 1 && uppercase == 1 && digit == 1 && special == 1)? true: false;
    }
};

int main(int argc, char **argv)
{
    string password = "IloveLe3tcode!";
    Solution S;

    cout << S.strongPasswordCheckerII(password);

    return 0;
}