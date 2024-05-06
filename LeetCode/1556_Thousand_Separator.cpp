class Solution
{
public:
    string thousandSeparator(int n)
    {
        if(n < 1000) return to_string(n);

        string str_n = to_string(n), str = "";
        for(int i = str_n.length()-1; i >= 0; i--)
        {
            str.insert(str.begin(), str_n[i]);
            if((str.length()+1)%4 == 0 && i != 0) str.insert(str.begin(), '.');
        }
        return str;
    }
};