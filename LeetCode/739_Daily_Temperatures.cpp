#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> dailyTemperatures(vector<int>& temperatures)
    {
        vector<int> WaitDays (temperatures.size(), 0);
        for(int i = 0; i < temperatures.size(); i++)
        {   
            int WaitDay = 0;

            if(i != 0 && temperatures[i] == temperatures[i-1])
            {
                if(WaitDays[i-1] == 0) WaitDays[i] = 0;
                else WaitDays[i] = WaitDays[i-1]-1;
                continue;
            }
            else
            {
                for(int j = i+1; j < temperatures.size(); j++)
                {
                    if(temperatures[j] > temperatures[i])
                    {
                        WaitDay = j-i;
                        break;
                    }
                }
                WaitDays[i] = WaitDay;
            }
        }
        return WaitDays;
    }

    void Show1DVector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> temperatures = {73,74,75,71,69,72,76,73};
    Solution S;

    S.Show1DVector(S.dailyTemperatures(temperatures));

    return 0;
}