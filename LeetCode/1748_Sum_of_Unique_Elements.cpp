#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int sumOfUnique(vector<int>& nums)
    {
        vector<vector<int>> num_cnt;
        int index = 0;
        for(int num: nums)
        {   
            int flag = 0;
            for(int i = 0; i < num_cnt.size(); i++)
            {
                if(num == num_cnt[i][0])
                {
                    flag = 1;
                    num_cnt[i][1]++;
                    break;
                }
            }
            if(flag == 0)
            {
                num_cnt.push_back(vector<int> ());
                num_cnt[index].push_back(num);
                num_cnt[index].push_back(1);
                index++;
            }
        }

        int sum = 0;
        for(vector<int> tmp: num_cnt) if(tmp[1] == 1) sum += tmp[0];
        return sum;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {1,2,3,2};
    Solution S;

    cout << S.sumOfUnique(nums);

    return 0;
}