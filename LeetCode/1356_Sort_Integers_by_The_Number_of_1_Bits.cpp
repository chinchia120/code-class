#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> sortByBits(vector<int>& arr)
    {
        vector<vector<int>> num_bits (arr.size(), vector<int> (2, 0));
        for(int i = 0; i < arr.size(); i++)
        {
            string str = "";
            int num = arr[i];
            while(true)
            {
                if(num < 2) 
                {
                    str.insert(str.begin(), num+'0');
                    break;
                }
                str.insert(str.begin(), num%2+'0');
                num /= 2;
            }

            int cnt = 0; 
            for(char ch: str)
            {
                if(ch == '1') cnt++;
            }
            num_bits[i][0] = arr[i];
            num_bits[i][1] = cnt;
        }
        //show_2d_vector(num_bits);

        for(int i = 0; i < num_bits.size(); i++)
        {
            for(int j = i+1; j < num_bits.size(); j++)
            {
                if((num_bits[i][1] > num_bits[j][1]) || (num_bits[i][1] == num_bits[j][1] && num_bits[i][0] > num_bits[j][0]))
                {
                    int tmp1 = num_bits[i][0];
                    num_bits[i][0] = num_bits[j][0];
                    num_bits[j][0] = tmp1;

                    int tmp2 = num_bits[i][1];
                    num_bits[i][1] = num_bits[j][1];
                    num_bits[j][1] = tmp2;
                }
            }
        }
        //show_2d_vector(num_bits);

        vector<int> sort_num_bits;
        for(vector<int> num: num_bits) sort_num_bits.push_back(num[0]);
        return sort_num_bits;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
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
    vector<int> arr = {0,1,2,3,4,5,6,7,8};
    Solution S;

    S.show_1d_vector(S.sortByBits(arr));

    return 0;
}