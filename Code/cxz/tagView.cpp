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

vector<string> tag;

vector<pair<int,double> > parseFeature(char* s){
	vector<pair<int,double> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id;
		double t=0;
		if (sscanf(p,"%d:%lf",&id,&t)>=1)
			res.PB(MP(id,t));
	}
	return res;
}

void loadDict(char * filename){
	FILE* fin=fopen(filename,"r");
	char s[10000];
	tag.clear();
	for (;fscanf(fin,"%s %*d",s)==1;){
		tag.PB(s);
	}
	fclose(fin);
}
int main(int argc,char **argv){
	if (argc!=4){
		puts("Argument Error");
		return 0;
	}

	loadDict(argv[1]);
	FILE* fin=fopen(argv[2],"r");
	FILE* fout=fopen(argv[3],"w");

	char s[1000000];
	for (;fgets(s,1000000,fin);){
		vector<pair<int,double> > pred=parseFeature(s);
		for (int i=0;i<pred.size();i++)
			fprintf(fout,"%s:%.5f ",tag[pred[i].first].c_str(),pred[i].second);
		fprintf(fout,"\n");
	}

	fclose(fin);
	fclose(fout);
	return 0;
}