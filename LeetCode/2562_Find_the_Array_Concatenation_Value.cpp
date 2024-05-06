#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    long long findTheArrayConcVal(vector<int>& nums)
    {   
        long long int sum = 0;
        while(!nums.empty())
        {
            if(nums.size() > 1)
            {
                string num1 = to_string(nums[0]), num2 = to_string(nums.back());
                for(char ch: num2) num1.push_back(ch);
                sum += stoi(num1);

                nums.erase(nums.begin());
                nums.erase(nums.begin()+nums.size()-1);
            }
            else
            {
                sum += nums[0];
                break;
            }
        }
        return sum;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {7,52,2,4};
    Solution S;

    cout << S.findTheArrayConcVal(nums);

    return 0;
}