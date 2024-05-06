class Solution
{
public:
    vector<int> createTargetArray(vector<int>& nums, vector<int>& index)
    {
        vector<int> TargetArray;
        for(int i = 0; i < nums.size(); i++)
        {
            TargetArray.insert(TargetArray.begin()+index[i], nums[i]);
        }
        return TargetArray;
    }
};