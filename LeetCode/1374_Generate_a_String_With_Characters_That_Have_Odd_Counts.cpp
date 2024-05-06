class Solution
{
public:
    string generateTheString(int n)
    {
        string str = "";
        if(n%2 == 0)
        {
            for(int i = 0; i < n-1; i++) str.push_back('a');
            str.push_back('b');
        }
        else
        {
            for(int i = 0; i < n; i++) str.push_back('a');
        }
        return str;
    }
};