#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <string>
#include <vector>
#include <queue>
#include <set>
#include <map>
#include <sstream>
#include <cctype>
using namespace std;

#define lowbit(x) ((x)&(-(x)))
#define sqr(x) ((x)*(x))
#define PB push_back
#define MP make_pair


int main(int argc,char** argv){
	if (argc!=4){
		puts("Argument Error");
		return 0;
	}
	FILE* fin=fopen(argv[1],"r");
	int K=atoi(argv[2]);
	FILE* fout=fopen(argv[3],"w");
	vector<pair<int,string> > dict;
	dict.clear();
	char s[100000];
	int cnt;
	for (;fscanf(fin,"%s%d",s,&cnt)==2;)
		dict.PB(MP(cnt,s));
	sort(dict.begin(),dict.end());
	reverse(dict.begin(),dict.end());
	for (int i=0;i<K;i++)
		fprintf(fout, "%s %d\n", dict[i].second.c_str(),dict[i].first);
	fclose(fin);
	fclose(fout);
	return 0;
}