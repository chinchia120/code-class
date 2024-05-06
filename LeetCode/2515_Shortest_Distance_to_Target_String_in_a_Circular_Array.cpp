#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int closetTarget(vector<string>& words, string target, int startIndex)
    {   
        if(words[startIndex] == target) return 0;

        vector<int> indexes;
        for(int i = 0; i < words.size(); i++) if(words[i] == target) indexes.push_back(i);
        if(indexes.empty()) return -1;
        
        int minLen = INT32_MAX, len = words.size();
        for(int index: indexes)
        {    
            if(index < startIndex) minLen = min(minLen, min(startIndex-index, index+len-startIndex));
            if(index > startIndex) minLen = min(minLen, min(index-startIndex, startIndex-index+len));
        }
        return minLen;
    }
};

int main(int argc, char **argv)
{   
    /*
    vector<string> words = {"hsdqinnoha","mqhskgeqzr","zemkwvqrww","zemkwvqrww","daljcrktje","fghofclnwp","djwdworyka","cxfpybanhd","fghofclnwp","fghofclnwp"};
    string target = "zemkwvqrww";
    int startIndex = 8;
    */
    vector<string> words = {"a","b","leetcode"};
    string target = "leetcode";
    int startIndex = 0;
    Solution S;

    cout << S.closetTarget(words, target, startIndex);

    return 0;
}