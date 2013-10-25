#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <iostream>
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

vector<pair<string,int> > dict;

void loadDict(char *filename){
	FILE* fin=fopen(filename,"r");
	char s[10000];
	int cnt;
	for (;fscanf(fin,"%s%d",s,&cnt)==2;)
		dict.PB(MP(s,cnt));
	fclose(fin);
}

bool cmp(pair<string,int> a,pair<string,int> b){
	return b.second<a.second;
}

void saveDict(char *filename,int cnt){
	sort(dict.begin(),dict.end(),cmp);
	FILE* fout=fopen(filename,"w");
	for (int i=0;i<min((int)dict.size(),cnt);i++)
		fprintf(fout,"%s\t%d\n",dict[i].first.c_str(),dict[i].second);
	fclose(fout);
}

int main(int argc,char** argv){
	if (argc!=4) {
		puts("Argument Error");
		return 0;
	}
	dict.clear();
	loadDict(argv[1]);
	saveDict(argv[2],atoi(argv[3]));
}