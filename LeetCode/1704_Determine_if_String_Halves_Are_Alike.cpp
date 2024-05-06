class Solution
{
public:
    bool halvesAreAlike(string s)
    {
        string str1 = "", str2 = "";
        for(int i = 0; i < s.length(); i++)
        {
            if(i < s.length()/2) str1.push_back(s[i]);
            else str2.push_back(s[i]);
        }
        
        int cnt1 = 0, cnt2 = 0;
        for(int i = 0; i < str1.length(); i++)
        {
            if(str1[i] == 'a' || str1[i] == 'e' || str1[i] == 'i' || str1[i] == 'o' || str1[i] == 'u' || 
            str1[i] == 'A' || str1[i] == 'E' || str1[i] == 'I' || str1[i] == 'O' || str1[i] == 'U' ) cnt1++;
            if(str2[i] == 'a' || str2[i] == 'e' || str2[i] == 'i' || str2[i] == 'o' || str2[i] == 'u' || 
            str2[i] == 'A' || str2[i] == 'E' || str2[i] == 'I' || str2[i] == 'O' || str2[i] == 'U' ) cnt2++;
        }
        return (cnt1 == cnt2) ? true : false;
    }
};