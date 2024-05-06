#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> twoOutOfThree(vector<int>& nums1, vector<int>& nums2, vector<int>& nums3)
    {   
        nums1 = RemoveSameElement(nums1);
        nums2 = RemoveSameElement(nums2);
        nums3 = RemoveSameElement(nums3);

        vector<vector<int>> num_fre;
        num_fre = CheckNumExist(nums1, num_fre);
        num_fre = CheckNumExist(nums2, num_fre);
        num_fre = CheckNumExist(nums3, num_fre);
        
        vector<int> twofre;
        for(vector<int> vec: num_fre)
        {
            if(vec[1] > 1) twofre.push_back(vec[0]);
        }
        return twofre;
    }

    vector<vector<int>> CheckNumExist(vector<int> nums, vector<vector<int>> num_fre)
    {   
        int index = num_fre.size();
        for(int num: nums)
        {
            int flag = 0;
            for(int i = 0; i < num_fre.size(); i++)
            {
                if(num == num_fre[i][0])
                {
                    flag = 1;
                    num_fre[i][1]++;
                    break;
                }
            }
            if(flag == 0)
            {
                num_fre.push_back(vector<int> ());
                num_fre[index].push_back(num);
                num_fre[index].push_back(1);
                index++;
            }
        }
        return num_fre;
    }

    vector<int> RemoveSameElement(vector<int> vec)
    {
        sort(vec.begin(), vec.end());

        vector<int> vecRemove;
        for(int num: vec)
        {
            if(!vecRemove.empty() && num == vecRemove.back()) continue;
            vecRemove.push_back(num);
        }
        return vecRemove;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(vector<int> nums: vec)
        {
            for(int num: nums) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<int> nums1 = {1,1,3,2}, nums2 = {2,3}, nums3 = {3};
    Solution S;

    S.show_1d_vector(S.twoOutOfThree(nums1, nums2, nums3));

    return 0;
}