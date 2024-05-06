#include <iostream>
using namespace std;

class Solution
{
public:
    string categorizeBox(int length, int width, int height, int mass)
    {
        bool flag1 = CheckBulky(length, width, height), flag2 = CheckHeavy(mass);

        if(flag1 == true && flag2 == true) return "Both";
        else if(flag1 == true && flag2 == false) return "Bulky";
        else if(flag1 == false && flag2 == true) return "Heavy";
        else return "Neither";
    }

    bool CheckBulky(int length, int width, int height)
    {
        if(length >= 10000 || width >= 10000 || height >= 10000 || (long long)length*width*height >= 1000000000) return true;
        else return false;
    }

    bool CheckHeavy(int mass)
    {
        if(mass >= 100) return true;
        else return false;
    }
};