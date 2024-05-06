#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    string maximumTime(string time)
    {
        for(int i = 0; i < time.length(); i+=3)
        {   
            if(i == 0)
            {
                if(time[i] == '?' && time[i+1] != '?')
                {
                    if(time[i+1]-'0' <= 3) time[i] = '2';
                    else time[i] = '1';
                }
                else if(time[i] != '?' && time[i+1] == '?')
                {
                    if(time[i]-'0' == 2) time[i+1] = '3';
                    else time[i+1] = '9';
                }
                else if(time[i] == '?' && time[i+1] == '?')
                {
                    time[i] = '2';
                    time[i+1] = '3';
                }
            }
            
            if(i == 3)
            {
                if(time[i] == '?' && time[i+1] != '?')
                {
                    time[i] = '5';
                }
                else if(time[i] != '?' && time[i+1] == '?')
                {
                    time[i+1] = '9';
                }
                else if(time[i] == '?' && time[i+1] == '?')
                {
                    time[i] = '5';
                    time[i+1] = '9';
                }
            }
        }
        return time;
    }
};

int main(int argc, char **argv)
{
    string time = "0?:3?";
    Solution S;

    cout << S.maximumTime(time);

    return 0;
}