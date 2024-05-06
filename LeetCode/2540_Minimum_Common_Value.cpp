#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int getCommon(vector<int>& nums1, vector<int>& nums2)
    {   
        int index = 0;
        for(int num1: nums1)
        {
            for(int i = index; i < nums2.size(); i++)
            {   
                if(num1 == nums2[i]) return num1;
                if(num1 < nums2[i])
                {
                    index = i;
                    break;
                }
                if(i == nums2.size()-1) return -1;
            }
        }
        return -1;    
    }
};

int main(int argc, char **argv)
{
    vector<int> nums1 = {1,2,3}, nums2 = {2,4};
    Solution S;

    cout << S.getCommon(nums1, nums2);

    return 0;
}