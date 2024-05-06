class Solution
{
public:
    vector<int> shuffle(vector<int>& nums, int n)
    {
        vector<int> vec_shuffle(nums.size(), 0);
        for(int i = 0; i < n; i++)
        {
            vec_shuffle[i*2] = nums[i];
            vec_shuffle[i*2+1] = nums[i+n];
        }
        return vec_shuffle;
    }
};