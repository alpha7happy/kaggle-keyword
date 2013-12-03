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

int main(int argc,char **argv){
	if (argc!=4){
		puts("Argument Error");
		return 0;
	}
	double thres;
	sscanf(argv[2],"%lf",&thres);
	FILE* fin=fopen(argv[1],"r");
	FILE* fout=fopen(argv[3],"w");

	char s[1000000];
	for (;fgets(s,1000000,fin);){
		vector<pair<int,double> > pred=parseFeature(s);
		double ma=pred[0].second;
		for (int i=0;i<pred.size();i++)
			if (i<2)
			if (pred[i].second/ma<1.01||i<1)
				fprintf(fout,"%d ",pred[i].first);
		fprintf(fout,"\n");
	}

	fclose(fin);
	fclose(fout);
	return 0;
}