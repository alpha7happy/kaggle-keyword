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

map<string,int> dict;

void loadFile(char *filename){
	bool istag=(strstr(filename,".Tags")!=0);
	FILE* fin=fopen(filename,"r");
	char s[100000];
	int cnt=0;
	for (;fscanf(fin,"%s",s)==1;){
		if (strlen(s)>20) continue;
		if (istag&&dict.find(s)==dict.end())
			printf("Only In Tags: %s\n",s);
		dict[s]++;
		cnt++;
		if (cnt%10000==0) fprintf(stderr,"\rLoading %s, #Word = %.2f, #Dict = %d",filename,cnt/1000000.,(int)dict.size());
	}
	fprintf(stderr,"\rFinish Loading %s, #Word = %.2f, #Dict = %d\n",filename,cnt/1000000.,(int)dict.size());
	fclose(fin);
}

void saveDict(char *filename){
	FILE* fout=fopen(filename,"w");
	for (map<string,int>::iterator itr=dict.begin();itr!=dict.end();itr++)
		fprintf(fout,"%s\t%d\n",itr->first.c_str(),itr->second);
	fclose(fout);
}

int main(int argc,char** argv){
	if (argc<3){
		puts("Argument Error, Usage:");
		puts("OutputFileName {InputFileName_i}");
		return 0;
	}
	dict.clear();
	for (int i=2;i<argc;i++)
		loadFile(argv[i]);
	saveDict(argv[1]);
}