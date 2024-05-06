#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minDeletionSize(vector<string>& strs)
    {
        vector<int> ascii_code, index;
        int cnt = 0;
        for(int i = 0; i < strs.size(); i++)
        {   
            string str = strs[i];
            for(int j = 0; j < str.length(); j++)
            {
                if(i == 0)
                {
                    ascii_code.push_back((int)str[j]);
                }
                else
                {
                    if(ascii_code[j] > str[j])
                    {   
                        int flag = 0;
                        for(int k = 0; k < index.size(); k++)
                        {
                            if(j == index[k])
                            {
                                flag = 1;
                                break;
                            }
                        }

                        if(flag == 0)
                        {
                            cnt++;
                            index.push_back(j);
                        }
                    }
                    else
                    {
                        ascii_code[j] = (int)str[j];
                    }
                }
            }
        }
        return cnt;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<string> strs = {"cba","daf","ghi"};
    Solution S;

    cout << S.minDeletionSize(strs);

    return 0;
}