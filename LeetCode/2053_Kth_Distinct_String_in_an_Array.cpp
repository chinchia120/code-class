#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    string kthDistinct(vector<string>& arr, int k)
    {   
        if(arr.size() == 1 && k == 1) return arr[0];
        else if(arr.size() == 1) return "";

        vector<string> str;
        vector<int> cnt;
        for(string _arr: arr)
        {
            int flag = 0;
            for(int i = 0; i < str.size(); i++)
            {
                if(str[i] == _arr)
                {
                    flag = 1;
                    cnt[i]++;
                    break;
                }
            }
            if(flag == 0)
            {
                str.push_back(_arr);
                cnt.push_back(1);
            }
        }
        //show_1d_vector(str);
        //show_1d_vector(cnt);

        vector<string> strRemove;
        for(int i = 0; i < str.size(); i++) if(cnt[i] == 1) strRemove.push_back(str[i]); 

        return (strRemove.size() >= k)? strRemove[k-1]: "";
    }

    /*
    void show_1d_vector(vector<auto> vec)
    {
        for(auto str: vec) cout << str << " ";
        cout << endl;
    }
    */
};

int main(int argc, char **argv)
{
    vector<string> arr = {"d","b","c","b","c","a"};
    int k = 2;
    Solution S;

    cout << S.kthDistinct(arr, k);

    return 0;
}