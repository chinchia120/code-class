#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countMatches(vector<vector<string>>& items, string ruleKey, string ruleValue)
    {
        int cnt = 0, indexCheck = 0;
        if(ruleKey == "type") indexCheck = 0;
        if(ruleKey == "color") indexCheck = 1;
        if(ruleKey == "name") indexCheck = 2;

        for(vector<string> item: items) if(item[indexCheck] == ruleValue) cnt++;
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<vector<string>> items = {{"phone","blue","pixel"},{"computer","silver","phone"},{"phone","gold","iphone"}};
    string ruleKey = "type", ruleValue = "phone";
    Solution S;

    cout << S.countMatches(items, ruleKey, ruleValue);

    return 0;
}