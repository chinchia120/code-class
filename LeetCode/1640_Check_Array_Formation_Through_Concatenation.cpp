#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool canFormArray(vector<int>& arr, vector<vector<int>>& pieces)
    {   
        int flag = 0;
        for(int i = 0; i < arr.size(); i++)
        {   
            //show_2d_vector(pieces);
            for(int j = 0; j < pieces.size(); j++)
            {
                if(arr[i] == pieces[j][0])
                {   
                    flag = 1;
                    for(int k = 0; k < pieces[j].size(); k++)
                    {
                        if(arr[i+k] != pieces[j][k]) return false;
                    }
                    i = i+pieces[j].size()-1;
                    pieces[j].clear();
                }
            }
        }
        //show_2d_vector(pieces);
        for(int i = 0; i < pieces.size(); i++)
        {
            if(!pieces[i].empty()) return false;
        }
        return true;
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
    vector<int> arr = {15,88};
    vector<vector<int>> pieces = {{15},{88}};
    Solution S;

    cout << S.canFormArray(arr, pieces);

    return 0;
}