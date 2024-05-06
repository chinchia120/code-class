class Solution
{
public:
    int findMiddleIndex(vector<int>& nums)
    {
        for(int i = 0; i < nums.size(); i++)
        {
            int sumR = 0, sumL = 0;
            for(int j = 0; j < i; j++) sumL += nums[j];
            for(int j = nums.size()-1; j > i; j--) sumR += nums[j];
            if(sumR == sumL) return i;
        }
        return -1;
    }
};