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

FILE* ftitle;
FILE* fbody;
FILE* ftag;
vector<string> body;
vector<set<int> >tag;
int Ntag;

vector<pair<int,int> > parseFeature(char* s){
	vector<pair<int,int> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id,cnt;
		if (sscanf(p,"%d:%d",&id,&cnt)==2)
			if (id!=-1)
				res.PB(MP(id,cnt));
	}
	return res;
}


int main(int argc,char** argv){
	if (argc!=){
		puts("Argument Error");
		return 0;
	}
	ftitle=fopen(argv[1],"r");
	fbody=fopen(argv[2],"r");
	ftag=fopen(argv[3],"r");
	Ntag=atoi(argv[4]);
	string svmdir=fopen(argv[])
	body.clear();
	tag.clear();
	for (;fgets(s,1000000,ftags);){
		cnt++;
		if (cnt%10000==0){
			printf("\rCalculating, #doc = %.2fM",cnt/1000000.);
			fflush(stdout);
		}
		set<int> ttag;
		ttag.clear();
		vector<pair<int,int> > ptag=parseFeature(s);
		for (int i=0;i<ptag.size();i++)
			ttag.insert(ptag[i].first);
		tag.PB(ttag);
		fgets(s,1000000,fbody);
		body.PB(s);
	}


	return 0;
}