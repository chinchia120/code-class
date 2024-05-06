#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> findKDistantIndices(vector<int>& nums, int key, int k)
    {   
        int prevEnd = 0;
        vector<int> DistantIndices;
        for(int i = 0; i < nums.size(); i++)
        {   
            
            if(nums[i] == key)
            {   
                int start = i-k, end = i+k+1;
                if(start < prevEnd) start = prevEnd;
                if(start < 0) start = 0;
                if(end > nums.size()) end = nums.size();

                for(int  j = start; j < end; j++) DistantIndices.push_back(j);
                prevEnd = end;
            }
        }
        return DistantIndices;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {2,2,2,2,2};
    int key = 2, k = 2;
    Solution S;

    S.show_1d_vector(S.findKDistantIndices(nums, key, k));

    return 0;
}