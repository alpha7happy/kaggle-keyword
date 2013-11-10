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

double ** tiwj;
double * ti;
double * wi;

vector<pair<int,string> > words,tags;
FILE* ftitle;
FILE* fbody;
FILE* ftags;
vector<pair<int,int> > title,body,tag;
char s[1000000];
int sum=0;

vector<pair<int,string> > loadDict(char* filename){
	FILE* fin=fopen(filename,"r");
	vector<pair<int,string> > dict;
	dict.clear();
	char s[10000];
	int cnt;
	for (;fscanf(fin,"%s%d",s,&cnt)==2;){
		dict.PB(MP(cnt,s));
		sum+=cnt;
	}
	fclose(fin);
	return dict;
}

int main(int argc,char** argv){
	if (argc!=9){
		puts("Argument Error");
		return 0;
	}
	srand(time(0));
	words=loadDict(argv[1]);
	tags=loadDict(argv[2]);
	ftitle=fopen(argv[3],"r");
	fbody=fopen(argv[4],"r");
	ftags=fopen(argv[5],"r");
	tiwj=new double*[(int)tags.size()];
	for (int i=0;i<(int)tags.size();i++)
		tiwj[i]=new double[(int)words.size()];
	ifstream ftiwj=(argv[6], ios::out | ios::binary);
	for (int i=0;i<(int)tags.size();i++)
		for (int j=0;j<(int)words.size();j++)
	/*
	int cnt=0;
	for (;fgets(s,1000000,ftags);){
		cnt++;
		if (cnt%10000==0){
			printf("\rCalculating, #doc = %.2fM",cnt/1000000.);
			fflush(stdout);
		}
		tag=parseFeature(s);
		fgets(s,1000000,fbody);
		body=parseFeature(s);
		for (int i=0;i<body.size();i++)
			for (int j=0;j<tag.size();j++)
				tiwj[tag[j].first][body[i].first]++;
	}
	printf("\rCalculating Finished, #doc= %.2fM\n",cnt/1000000.);
	fclose(ftitle);
	fclose(fbody);
	fclose(ftags);*/
	return 0;
}