class Solution
{
public:
    int xorOperation(int n, int start)
    {   
        if(n == 1) return start;
        
        int XOR = start ^ start+2;
        for(int i = 2; i < n; i++) XOR = XOR ^ start+i*2;
        return XOR;
    }
};