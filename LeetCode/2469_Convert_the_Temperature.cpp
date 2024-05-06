#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<double> convertTemperature(double celsius)
    {
        return vector<double> {celsius+273.15, celsius*1.80+32.00};
    }

    void Show1DVector(vector<double> nums)
    {
        for(double num: nums) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    double celsius = 36.50;
    Solution S;

    S.Show1DVector(S.convertTemperature(celsius));

    return 0;
}