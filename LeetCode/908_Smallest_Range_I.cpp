class Solution {
public:
    int smallestRangeI(vector<int>& nums, int k) {
        sort(nums.begin(), nums.end());
        //show_1d_vector(nums);

        int diff = nums.back() - nums[0];
        if(diff <= 2*k) diff = 0;
        else diff -= 2*k;
        
        return diff;
    }
    
    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};