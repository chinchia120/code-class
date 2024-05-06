class Solution
{
public:
    string modifyString(string s)
    {
        for(int i = 0; i < s.length(); i++)
        {
            if(s[i] == '?')
            {
                if(i == 0)
                {
                    for(int j = 97; j <= 132; j++)
                    {
                        if((int)s[i+1] != j)
                        {
                            s[i] = char(j);
                            break;
                        }
                    }
                }
                else if(i == s.length()-1)
                {
                    for(int j = 97; j <= 132; j++)
                    {
                        if((int)s[i-1] != j)
                        {
                            s[i] = char(j);
                            break;
                        }
                    }
                }
                else
                {
                    for(int j = 97; j <= 132; j++)
                    {
                        if((int)s[i-1] != j && (int)s[i+1] != j)
                        {
                            s[i] = char(j);
                            break;
                        }
                    }
                }
            }
        }
        return s;
    }
};