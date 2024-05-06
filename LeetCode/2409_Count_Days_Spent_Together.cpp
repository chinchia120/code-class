#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution
{
public:
    int countDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob)
    {
        int montharriveAlice = stoi(arriveAlice.substr(0, 2)), dayarriveAlice = stoi(arriveAlice.substr(3, 2));
        int montharriveBob = stoi(arriveBob.substr(0, 2)), dayarriveBob = stoi(arriveBob.substr(3, 2));
        int monthleaveAlice = stoi(leaveAlice.substr(0, 2)), dayleaveAlice = stoi(leaveAlice.substr(3, 2));
        int monthleaveBob = stoi(leaveBob.substr(0, 2)), dayleaveBob = stoi(leaveBob.substr(3, 2));
        int montharrive, dayarrive, monthleave, dayleave;

        if(montharriveBob > monthleaveAlice || (montharriveBob == monthleaveAlice && dayarriveBob > dayleaveAlice)) return 0;
        //if(montharriveBob < monthleaveAlice || (montharriveBob == monthleaveAlice && dayarriveBob > dayleaveAlice)) return 0;

        if(montharriveAlice > montharriveBob)
        {
            montharrive = montharriveAlice;
            dayarrive = dayarriveAlice;
        }
        else if(montharriveAlice == montharriveBob)
        {
            montharrive = montharriveAlice;
            dayarrive = max(dayarriveAlice, dayarriveBob);
        }
        else
        {
            montharrive = montharriveBob;
            dayarrive = dayarriveBob;
        }
        
        if(monthleaveAlice < monthleaveBob)
        {
            monthleave = monthleaveAlice;
            dayleave = dayleaveAlice;
        }
        else if(monthleaveAlice == monthleaveBob)
        {
            monthleave = monthleaveAlice;
            dayleave = min(dayleaveAlice, dayleaveBob);
        }
        else
        {
            monthleave = monthleaveBob;
            dayleave = dayleaveBob;
        }

        //cout << montharrive << " " << dayarrive << endl;;
        //cout << monthleave << " " << dayleave << endl;

        vector<int> dayofmonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int count;
        if(montharrive == monthleave) count = dayleave-dayarrive+1;
        else 
        {
            for(int i = montharrive; i <= monthleave; i++)
            {
                if(i == montharrive) count += dayofmonth[i-1]-dayarrive+1;
                else if(i == monthleave) count += dayarrive;
                else count += dayofmonth[i-1];
            }
        }
        return count;
    }
};

int main(int argc, char **argv)
{
    string arriveAlice = "08-15", leaveAlice = "08-18", arriveBob = "08-16", leaveBob = "08-19";
    Solution S;

    cout << S.countDaysTogether(arriveAlice, leaveAlice, arriveBob, leaveBob);

    return 0;
}