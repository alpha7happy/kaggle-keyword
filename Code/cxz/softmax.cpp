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

vector<pair<int,double> > parseFeature(char* s){
	vector<pair<int,double> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id;
		double value;
		if (sscanf(p,"%d:%lf",&id,&value)==2)
			if (id!=-1)
				res.PB(MP(id,value));
	}
	return res;
}

char s[1000000];

int main(int argc,char** argv){
	FILE* fin=fopen(argv[1],"r");
	FILE* fout=fopen(argv[2],"w");
		for (;fgets(s,1000000,fin);){
			vector<pair<int,double> > data=parseFeature(s);
			double sum=0;
			double t=-1e300;
			for (int i=0;i<data.size();i++)
				t=max(t,data[i].second);
			for (int i=0;i<data.size();i++)
				sum+=exp(data[i].second-t);
			for (int i=0;i<data.size();i++)
				fprintf(fout,"%d:%.6f ",data[i].first,exp(data[i].second-t)/sum);
			fprintf(fout,"\n");
		}
	fclose(fin);
	fclose(fout);
	return 0;
}