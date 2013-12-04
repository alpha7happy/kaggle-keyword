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

vector<int> parseFeature(char* s){
	vector<int> res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id;
		if (sscanf(p,"%d:%*s",&id)==1)
			res.PB(id);
	}
	return res;
}

int main(int argc,char** argv){
	if (argc<4){
		puts("Argument Error, Usage:");
		return 0;
	}
	dict.clear();
	FILE* fin=fopen(argv[1],"r");
	int N=atoi(argv[2]);
	FILE* fout=fopen(argv[3],"w");
	char s[1000000];
	vector<int> cnt;
	cnt.clear();
	for (int i=0;i<N;i++) cnt.PB(0);
	int ndoc=0;
	for (;fgets(s,1000000,fin);){
		ndoc++;
		vector<int> data=parseFeature(s);
		for (int i=0;i<data.size();i++)
			cnt[data[i]]++;
	}
	for (int i=0;i<N;i++) 
		fprintf(fout,"%.10f\n",log(ndoc/(double)cnt[i]));
	fclose(fin);
	fclose(fout);
}