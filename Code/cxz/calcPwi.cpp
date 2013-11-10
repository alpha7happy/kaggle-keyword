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

vector<pair<int,string> > dict;
char s[1000000];
FILE* fout;
int sum=0;

void loadDict(char* filename){
	FILE* fin=fopen(filename,"r");
	dict.clear();
	char s[10000];
	int cnt;
	for (;fscanf(fin,"%s%d",s,&cnt)==2;){
		cnt++;
		dict.PB(MP(cnt,s));
		sum+=cnt;
	}
	fclose(fin);
}

int main(int argc,char **argv){
	if (argc!=3){
		puts("Argument Error");
		return 0;
	}
	srand(time(0));
	loadDict(argv[1]);
	fout=fopen(argv[2],"w");
	for (int i=0;i<dict.size();i++)
		fprintf(fout,"%.10f\n",log((double)dict[i].first)-log((double)sum));
	fclose(fout);
	return 0;
}