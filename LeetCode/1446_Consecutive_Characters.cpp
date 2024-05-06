class Solution
{
public:
    int maxPower(string s)
    {   
        int cnt = 1, len = 1;
        char prev = s[0];
        for(int i = 1; i < s.length(); i++)
        {
            if(s[i] == prev) cnt++;
            else
            {
                len = max(len, cnt);
                cnt = 1;
                prev = s[i];
            }
        }
        len = max(len, cnt);
        return len;
    }
};