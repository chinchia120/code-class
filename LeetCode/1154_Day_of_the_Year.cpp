#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution
{
public:
    int dayOfYear(string date)
    {
        int year = stoi(date.substr(0, 4)), month = stoi(date.substr(5, 7)), day = stoi(date.substr(8, 10));
        
        vector<int> DayofMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        if(check_leap_year(year)) DayofMonth[1] = 29;
        
        int sum = 0;
        for(int i = 0; i < month-1; i++) sum+= DayofMonth[i];
        
        return sum+day;
    }

    bool check_leap_year(int n)
    {
        if(n%4 == 0)
        {
            if(n%100 == 0 && n%400 != 0) return false;
            else return true;
        }
        else
        {
            return false;
        }
    }
};

int main(int argc, char **argv)
{
    string date = "2000-12-04";
    Solution S;

    cout << S.dayOfYear(date);

    return 0;
}