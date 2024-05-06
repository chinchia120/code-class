#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    string oddString(vector<string>& words)
    {
        vector<vector<int>> diffs;
        int index1 = 0, index2 = 0;
        for(int i = 0; i < words.size(); i++)
        {
            vector<int> tmp;
            string word = words[i];
            for(int j = 1; j < word.length(); j++) tmp.push_back((int)word[j]-(int)word[j-1]);
            
            if(diffs.size() == 0) 
            {
                diffs.push_back(tmp);
                index1 = i;
            }
            else if(diffs.size() == 1 && diffs[0] != tmp)
            {
                diffs.push_back(tmp);
                index2 = i;
            }
            else if(diffs.size() == 2)
            {
                if(diffs[0] == tmp) return words[index2];
                if(diffs[1] == tmp) return words[index1];
            }
        }
        //Show2DVector(diffs);
        return words.back();
    }

    void Show1DVector(vector<int> nums)
    {
        for(int num: nums) cout << num << " ";
        cout << endl;
    }

    void Show2DVector(vector<vector<int>> vec)
    {
        for(vector<int> nums: vec) 
        {
            for(int num: nums) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<string> words = {"adc","wzy","abc"};
    Solution S;

    cout << S.oddString(words);

    return 0;
}