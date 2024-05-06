#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    string dayOfTheWeek(int day, int month, int year)
    {
        vector<int> DayofMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        vector<string> days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
        if(isLeapYear(year)) DayofMonth[1] = 29;

        int index_days = 4, totalday = 0;
        for(int i = 1971; i <= year; i++)
        {   
            index_days += isLeapYear(i-1) ? 2 : 1;
            if(index_days > 7) index_days -= 7;
        }

        for(int i = 0; i < month-1; i++) totalday += DayofMonth[i];
        totalday += day;

        index_days += totalday%7 - 1;
        
        return (index_days > 6) ? days[index_days-7] : days[index_days];
    }

    bool isLeapYear(int year)
    {
        return (year%400 == 0) || (year%100 != 0 && year%4 == 0);
    }
};

int main(int argc, char **argv)
{
    int day = 31, month = 8, year = 2019;
    Solution S;

    cout << S.dayOfTheWeek(day, month, year);

    return 0;
}