#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> frequencySort(vector<int>& nums)
    {
        vector<vector<int>> fre_num;
        int index = 0;
        for(int num: nums)
        {   
            int flag = 0;
            for(int i = 0; i < fre_num.size(); i++)
            {
                if(fre_num[i][1] == num)
                {
                    flag = 1;
                    fre_num[i][0]++;
                    break;
                }
            }
            if(flag == 0)
            {
                fre_num.push_back(vector<int> ());
                fre_num[index].push_back(1);
                fre_num[index].push_back(num);
                index++;
            }
        }
        //show_2d_vector(fre_num);

        for(int i = 0; i < fre_num.size(); i++)
        {
            for(int j = i+1; j < fre_num.size(); j++)
            {
                if((fre_num[i][0] > fre_num[j][0]) || 
                (fre_num[i][0] == fre_num[j][0] && fre_num[i][1] < fre_num[j][1]))
                {
                    int tmp1 = fre_num[i][0];
                    fre_num[i][0] = fre_num[j][0];
                    fre_num[j][0] = tmp1;

                    int tmp2 = fre_num[i][1];
                    fre_num[i][1] = fre_num[j][1];
                    fre_num[j][1] = tmp2;
                }
            }
        }
        //show_2d_vector(fre_num);

        vector<int> sortbyfrequency;
        for(int i = 0; i < fre_num.size(); i++)
        {
            for(int j = 0; j < fre_num[i][0]; j++) sortbyfrequency.push_back(fre_num[i][1]);
        }
        return sortbyfrequency;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(vector<int> vec1: vec)
        {
            for(int num: vec1) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {2,3,1,3,2};
    Solution S;

    S.show_1d_vector(S.frequencySort(nums));

    return 0;
}