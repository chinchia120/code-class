#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution 
{
public:
    vector<int> relativeSortArray(vector<int>& arr1, vector<int>& arr2)
    {
        sort(arr1.begin(), arr1.end());

        vector<int> RelativeSortArray;
        for(int i = 0; i < arr2.size(); i++)
        {   
            int cnt = 0, index = 0;
            for(int j = 0; j < arr1.size(); j++)
            {
                if(arr2[i] == arr1[j])
                {
                    cnt++;
                    index = j;
                }
            }

            for(int j = 0; j < cnt; j++)
            {
                RelativeSortArray.push_back(arr2[i]);
                arr1.erase(arr1.begin()+index-cnt+1);
            }
        }
        
        for(int i = 0; i < arr1.size(); i++) RelativeSortArray.push_back(arr1[i]);

        return RelativeSortArray;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr1 = {2,3,1,3,2,4,6,7,9,2,19}, arr2 = {2,1,4,3,9,6};
    Solution S;

    S.show_1d_vector(S.relativeSortArray(arr1, arr2));

    return 0;
}