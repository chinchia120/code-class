#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> maxSubsequence(vector<int>& nums, int k)
    {   
        vector<int> numsCopy = nums;
        sort(nums.begin(), nums.end());
        
        vector<int> sequence_sort;
        for(int i = nums.size()-k; i < nums.size(); i++) sequence_sort.push_back(nums[i]);

        vector<int> sequence;
        for(int num: numsCopy)
        {
            for(int i = 0; i < sequence_sort.size(); i++)
            {
                if(sequence_sort[i] == num)
                {
                    sequence.push_back(num);
                    sequence_sort.erase(sequence_sort.begin()+i);
                    break;
                }
            }
        }
        return sequence;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {50,-75};
    int k = 2;
    Solution S;

    S.show_1d_vector(S.maxSubsequence(nums, k));

    return 0;
}