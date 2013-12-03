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

vector<pair<double,int> > parseFeature(char* s){
	vector<pair<double,int> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id;
		double t=0;
		if (sscanf(p,"%d:%lf",&id,&t)>=1)
			res.PB(MP(t,id));
	}
	sort(res.begin(),res.end());
	reverse(res.begin(),res.end());
	return res;
}

int main(int argc,char **argv){
	if (argc!=4){
		puts("Argument Error");
		return 0;
	}
	int K=atoi(argv[2]);
	FILE* fin=fopen(argv[1],"r");
	FILE* fout=fopen(argv[3],"w");

	char s[1000000];
	for (;fgets(s,1000000,fin);){
		vector<pair<double,int> > pred=parseFeature(s);
		//reverse(pred.begin(),pred.end());
		for (int i=0;i<min(K,(int)pred.size());i++)
			fprintf(fout,"%d ",pred[i].second);
		fprintf(fout,"\n");
	}

	fclose(fin);
	fclose(fout);
	return 0;
}