#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    double calculateTax(vector<vector<int>>& brackets, int income)
    {
        double tax = 0;
        for(int i = 0; i < brackets.size(); i++)
        {   
            if(i == 0)
            {
                if(brackets[i][0] > income)
                {
                    tax += income*brackets[i][1];
                    break;
                }
                else
                {
                    tax += brackets[i][0]*brackets[i][1];
                    income -= brackets[i][0];
                }
            }
            else
            {
                if(brackets[i][0]-brackets[i-1][0] > income)
                {
                    tax += income*brackets[i][1];
                    break;
                }
                else
                {
                    tax += (brackets[i][0]-brackets[i-1][0])*brackets[i][1];
                    income -= brackets[i][0]-brackets[i-1][0];
                }
            }
        }
        return tax/100;
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> brackets = {{2,7},{3,17},{4,37},{7,6},{9,83},{16,67},{19,29}};
    int income = 18;
    Solution S;

    cout << S.calculateTax(brackets, income);

    return 0;
}