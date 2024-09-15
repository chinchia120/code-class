#include <iostream>
using namespace std;

class Solution
{
public:
    int distanceTraveled(int mainTank, int additionalTank)
    {   
        if (additionalTank == 0) return mainTank * 10;

        int cnt = 0;
        while (true)
        {
            if (mainTank < 5)
            {
                cnt += mainTank;
                break;
            }
            else
            {
                if(additionalTank > 0)
                {
                    mainTank -= 4;
                    additionalTank--;
                    cnt += 5;
                }
                else
                {
                    cnt += mainTank;
                    break;
                }
            }
        }
        return cnt * 10;
    }
};

int main(int argc, char * argv[])
{   
    int mainTank = 5, additionalTank = 10;
    Solution S;
    cout << S.distanceTraveled(mainTank, additionalTank);

    return 0;
}