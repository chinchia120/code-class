#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> replaceElements(vector<int>& arr)
    {   
        for(int i = 0; i < arr.size()-1; i++)
        {   
            int max_num = 0, max_index = 0;
            for(int j = i+1; j < arr.size(); j++)
            {   
                if(max_num < arr[j])
                {
                    max_num = max(max_num, arr[j]);
                    max_index = j;
                }
            }
            cout << max_index << " " << max_num << endl;
            for(int j = i; j < max_index; j++) 
            {
                arr[j] = max_num;
                cout << arr[j] << " " << endl;
            }
            i = max_index-1;
        }
        arr[arr.size()-1] = -1;
        return arr;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {17,18,5,4,6,1};
    Solution S;

    S.show_1d_vector(S.replaceElements(arr));

    return 0;
}