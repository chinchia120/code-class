class Solution
{
public:
    string makeGood(string s)
    {
        string str = "";
        str.push_back(s[0]);

        for(int i = 1; i < s.length(); i++)
        {
            if(!str.empty() && ((int)s[i]-32 == (int)str.back() || (int)s[i]+32 == (int)str.back()))
            {   
                str.pop_back();
            }
            else
            {
                str.push_back(s[i]);
            }
        }
        return str;
    }
};