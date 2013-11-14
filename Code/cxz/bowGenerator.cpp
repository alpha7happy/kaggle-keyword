#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <cctype>
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

FILE* fout;
FILE* fin;
map<string,int> rid;
char s[1000000];

void loadDict(char* filename){
	FILE* fin=fopen(filename,"r");
	rid.clear();
	for (;fscanf(fin,"%s%*d",s)==1;)
		rid[s]=rid.size();
	fclose(fin);
}

int main(int argc,char** argv){
	if (argc!=4){
		puts("Argument Error");
		return 0;
	}
	bool isTag=(strstr(argv[3],"tagBOW")!=0);
	loadDict(argv[1]);
	puts("Dictionary Loaded");
	fin=fopen(argv[2],"r");
	fout=fopen(argv[3],"w");
	int cnt=0;
	for (;fgets(s,1000000,fin);){
		cnt++;
		if (cnt%10000==0){
			printf("\rLoading, #Row = %.2fM",cnt/1000000.);
			fflush(stdout);
		}
		map<int,int> bow;
		bow.clear();
		for (char* p=strtok(s," ");p;p=strtok(NULL," "))
			if (rid.find(p)!=rid.end())
				bow[rid[p]]++;
			else if (isTag)
				bow[-1]++;
		for (map<int,int>::iterator itr=bow.begin();itr!=bow.end();itr++)
			fprintf(fout,"%d:%d ",itr->first,itr->second);
		fprintf(fout,"\n");
	}
	printf("\rLoading Finished\n");
	fclose(fin);
	fclose(fout);
}