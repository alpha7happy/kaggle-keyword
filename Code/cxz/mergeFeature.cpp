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

vector<string> fstr;

vector<pair<int,string> > parseFeature(char* s){
	vector<pair<int,string> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id;
		char ts[100];
		if (sscanf(p,"%d:%s",&id,ts)==2)
			if (id!=-1)
				res.PB(MP(id,ts));
	}
	return res;
}

string toData(vector<pair<int,string> > data,int stid){
	char s[1000000];
	int len=0;
	sort(data.begin(),data.end());
	for (int i=0;i<data.size();i++){
		sprintf(s+len,"%d:%s ",stid+data[i].first,data[i].second.c_str());
		len+=strlen(s+len);
	}
	return s;
}

char s[1000000];

int main(int argc,char** argv){
	int Nfeature=atoi(argv[1]);
	int stid=1;
	int narg=2;
	fstr.clear();
	for (int i=0;i<Nfeature;i++){
		int cnt=0;
		FILE* fin=fopen(argv[narg++],"r");
		for (;fgets(s,1000000,fin);){
			vector<pair<int,string> > data=parseFeature(s);
			if (i==0) fstr.PB("");
			fstr[cnt]=fstr[cnt]+toData(data,stid);
			cnt++;
			if (cnt%1000==0){
				printf("\rLoading Row %d",cnt);
				fflush(stdout);
			}
		}
		printf("\rLoading Finished for %s\n",argv[narg-1]);
		fclose(fin);
		stid+=atoi(argv[narg++]);
	}
	FILE* fout=fopen(argv[narg],"w");
	for (int i=0;i<fstr.size();i++)
		fprintf(fout,"%s\n",fstr[i].c_str());
	fclose(fout);
	return 0;
}