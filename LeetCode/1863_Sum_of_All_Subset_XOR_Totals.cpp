#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int subsetXORSum(vector<int>& nums)
    {   
        int sum = 0;
        for(int i = 1; i <= nums.size(); i++)
        {   
            int index = 0;
            for(int j = index; j < index+i; j++)
            {
                for(int k = j; k < j+nums.size()-i+1; k++) cout << k << " ";
                cout << endl;
            }
            cout << endl;
        }
       return sum;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {3,4,5,6,7,8};
    Solution S;

    cout << S.subsetXORSum(nums);

    return 0;
}