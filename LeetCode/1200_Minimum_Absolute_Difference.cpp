#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<vector<int>> minimumAbsDifference(vector<int>& arr)
    {
        sort(arr.begin(), arr.end());

        int min_diff = 999999;
        for(int i = 0; i < arr.size()-1; i++)
        {
            min_diff = min(min_diff, arr[i+1]-arr[i]);
        }

        vector<vector<int>> min_diff_arr;
        int index = 0;
        for(int i = 0; i < arr.size()-1; i++)
        {
            if(arr[i+1]-arr[i] == min_diff)
            {
                min_diff_arr.push_back(vector<int> ());
                min_diff_arr[index].push_back(arr[i]);
                min_diff_arr[index].push_back(arr[i+1]);
                index++;
            }
        }
        return min_diff_arr;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(int i = 0; i < vec.size(); i++)
        {
            for(int j = 0; j < vec[i].size(); j++) cout << vec[i][j] << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {3,8,-10,23,19,-4,-14,27};
    Solution S;

    S.show_2d_vector(S.minimumAbsDifference(arr));

    return 0;
}