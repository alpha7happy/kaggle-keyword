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
#include <fstream>
using namespace std;

#define lowbit(x) ((x)&(-(x)))
#define sqr(x) ((x)*(x))
#define PB push_back
#define MP make_pair

char s[1000000];
int main(int argc,char** argv){
	if (argc!=3){
		puts("Argument Error");
		return 0;
	}
	FILE* fdata=fopen(argv[1],"r");
	FILE* ftestdata=fopen(argv[2],"w");
	int cnt=0;
	for (;fgets(s,1000000,fdata);){
		cnt++;
		if (cnt%10000==0){
			printf("\rCalculating, #doc = %.2fM",cnt/1000000.);
			fflush(stdout);
		}
		fprintf(ftestdata,"%d %s",0,s);
	}
	fclose(ftestdata);
	return 0;
}