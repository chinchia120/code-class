#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution
{
public:
    int daysBetweenDates(string date1, string date2)
    {
        int year1 = stoi(date1.substr(0, 4)), month1 = stoi(date1.substr(5, 7)), day1 = stoi(date1.substr(8, 10));
        int year2 = stoi(date2.substr(0, 4)), month2 = stoi(date2.substr(5, 7)), day2 = stoi(date2.substr(8, 10));
        
        if((year1 > year2) || (year1 == year2 && month1 > month2) || (year1 == year2 && month1 == month2 && day1 > day2))
        {
            int tmp1 = year1;
            year1 = year2;
            year2 = tmp1;

            int tmp2 = month1;
            month1 = month2;
            month2 = tmp2;

            int tmp3 = day1;
            day1 = day2;
            day2 = tmp3;
        }

        vector<int> DayofMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int sum1 = 0, sum2 = 0;
        for(int i = 0; i < month1-1; i++)
        {
            if(i == 1) (isLeapYear(year1)) ? sum1 += 29 : sum1 += 28;
            else sum1 += DayofMonth[i];
        }
        sum1 += day1;

        for(int i = year1; i < year2; i++)
        {
            (isLeapYear(i)) ? sum2 += 366 : sum2 += 365; 
        }
        for(int i = 0; i < month2-1; i++)
        {
            if(i == 1) (isLeapYear(year2)) ? sum2 += 29 : sum2 += 28;
            else sum2 += DayofMonth[i];
        }
        sum2 += day2;

        cout << sum1 << " " << sum2 << endl;

        return sum2-sum1;
    }

    bool isLeapYear(int year)
    {
        return (year%400 == 0) || (year%100 != 0 && year%4 == 0);
    }
};

int main(int argc, char **argv)
{
    string date1 = "2009-08-18", date2 = "2080-08-08";
    Solution S;

    cout << S.daysBetweenDates(date1, date2);

    return 0;
}