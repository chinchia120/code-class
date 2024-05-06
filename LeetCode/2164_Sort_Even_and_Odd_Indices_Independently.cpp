#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> sortEvenOdd(vector<int>& nums)
    {
        for(int i = 0; i < nums.size(); i++)
        {
            for(int j = i+1; j < nums.size(); j++)
            {
                if(i%2 == j%2 && i%2 == 1 && nums[i] < nums[j])
                {
                    int tmp = nums[i];
                    nums[i] = nums[j];
                    nums[j] = tmp;
                }

                if(i%2 == j%2 && i%2 == 0 && nums[i] > nums[j])
                {
                    int tmp = nums[i];
                    nums[i] = nums[j];
                    nums[j] = tmp;
                }
            }
        }
        return nums;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {4,1,2,3};
    Solution S;

    S.show_1d_vector(S.sortEvenOdd(nums));

    return 0;
}