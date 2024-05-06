#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minStartValue(vector<int>& nums)
    {   
        int StartValue = 1;
        while(1)
        {   
            int flag = 0, sum = StartValue;
            for(int num: nums)
            {
                sum += num;
                if(sum < 1)
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) return StartValue;
            StartValue++;
        }
        return 0;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {-3,2,-3,4,2};
    Solution S;

    cout << S.minStartValue(nums);

    return 0;
}