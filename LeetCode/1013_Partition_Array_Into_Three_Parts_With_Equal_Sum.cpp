#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool canThreePartsEqualSum(vector<int>& arr)
    {   
        int sum = 0;
        for(int i = 0; i < arr.size(); i++) sum += arr[i];

        if(sum%3 != 0) return false;

        int sum1 = 0, sum2 = 0, sum3 = 0, loop = 1;
        for(int i = 0; i < arr.size(); i++)
        {
            if(loop == 1)
            {
                sum1 += arr[i];
                if(sum1 == sum/3) loop = 2;
            }
            else if(loop == 2)
            {
                sum2 += arr[i];
                if(sum2 == sum/3) loop = 3;
            }
            else
            {   
                loop = 4;
                sum3 += arr[i];
            }
        }
        if(sum3 == sum2 && loop == 4) return true;
        else return false;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {1,-1,1,-1};
    Solution S;

    cout << S.canThreePartsEqualSum(arr);

    return 0;
}