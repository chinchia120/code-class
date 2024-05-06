x

int main(int argc, char **argv)
{
    int n = 3;
    //vector<vector<int>> trust = {{1,3},{2,3},{3,1}};
    vector<vector<int>> trust = {{1,2},{2,3}};
    Solution S;

    cout << S.findJudge(n, trust);

    return 0;
}