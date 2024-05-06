#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> numberOfPairs(vector<int>& nums)
    {
        vector<vector<int>> Counts = CountNumber(nums);
        vector<int> Pairs (2, 0);
        for(vector<int> Count: Counts)
        {
            Pairs[1] += Count[1]%2;
            Pairs[0] += Count[1]/2;
        }
        return Pairs;
    }

    vector<vector<int>> CountNumber(vector<int> nums)
    {   
        int index = 0;
        vector<vector<int>> Counts;
        for(int num: nums)
        {
            int flag = 0;
            for(int i = 0; i < Counts.size(); i++)
            {
                if(num == Counts[i][0])
                {
                    flag = 1;
                    Counts[i][1]++;
                    break;
                }
            }
            if(flag == 0)
            {
                Counts.push_back(vector<int> ());
                Counts[index].push_back(num);
                Counts[index].push_back(1);
                index++;
            }
        }
        return Counts;
    }

    void Shoe1DVector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {1,3,2,1,3,2,2};
    Solution S;

    S.Shoe1DVector(S.numberOfPairs(nums));

    return 0;
}