#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> arrayRankTransform(vector<int>& arr)
    {
        vector<int> arr_sort = arr;
        sort(arr_sort.begin(), arr_sort.end());

        vector<int> rank_sort = {1};
        for(int i = 1; i < arr_sort.size(); i++)
        {
            (arr_sort[i] == arr_sort[i-1]) ? rank_sort.push_back(rank_sort.back()) : rank_sort.push_back(rank_sort.back()+1);
        }

        vector<int> rank;
        for(int i = 0; i < arr.size(); i++)
        {
            int index = distance(arr_sort.begin(), find(arr_sort.begin(), arr_sort.end(), arr[i]));
            rank.push_back(rank_sort[index]);
        }
        return rank;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {37,12,28,9,100,56,80,5,12};
    Solution S;

    S.show_1d_vector(S.arrayRankTransform(arr));

    return 0;
}