class Solution
{
public:
    vector<int> mostVisited(int n, vector<int>& rounds)
    {   
        vector<int> sector (n, 0);
        sector[rounds[0]-1]++;
        for(int i = 0; i < rounds.size()-1; i++)
        {
            int start = rounds[i], end = rounds[i+1];
            if(end <= start) end += n;

            for(int j = start+1; j <= end; j++)
            {
                if(j > n) sector[(j-1)%n]++;
                else sector[j-1]++;
            }
        }

        int maxCnt = 0;
        for(int num: sector) maxCnt = max(maxCnt, num);

        vector<int> maxSector;
        for(int i = 0; i < sector.size(); i++) if(sector[i] == maxCnt) maxSector.push_back(i+1);
        return maxSector;
    }
    
    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};