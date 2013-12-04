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
char s[1000000];
vector<double> idf;

void loadDict(char* filename){
	FILE* fin=fopen(filename,"r");
	double value;
	int id;
	for (;fscanf(fin,"%lf",&value)==1;)
		idf.PB(value);
	fclose(fin);
}

vector<pair<int,int> > parseFeature(char* s){
	vector<pair<int,int> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id;
		int value;
		if (sscanf(p,"%d:%d",&id,&value)==2)
			if (id!=-1)
				res.PB(MP(id,value));
	}
	return res;
}

int main(int argc,char** argv){
	if (argc!=4){
		puts("Argument Error");
		return 0;
	}
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
		vector<pair<int,int> > data=parseFeature(s);
		for (int i=0;i<data.size();i++)
			fprintf(fout,"%d:%.5f ",data[i].first,data[i].second*idf[data[i].first]);
		fprintf(fout,"\n");
	}
	printf("\rLoading Finished\n");
	fclose(fin);
	fclose(fout);
}