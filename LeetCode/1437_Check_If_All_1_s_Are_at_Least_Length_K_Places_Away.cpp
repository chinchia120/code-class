class Solution
{
public:
    bool kLengthApart(vector<int>& nums, int k)
    {   
        int StartIndex = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            if(nums[i] == 1)
            {
                StartIndex = i;
                break;
            }
        }

        int PrevIndex = StartIndex;
        for(int i = StartIndex+1; i < nums.size(); i++)
        {
            if(nums[i] == 1)
            {
                if(i-PrevIndex-1 < k) return false;
                else PrevIndex = i;
            }
        }
        return true;
    }
};