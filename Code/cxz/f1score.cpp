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

vector<int> parseFeature(char* s){
	vector<int> res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id;
		if (sscanf(p,"%d:%*d",&id)==1)
			res.PB(id);
	}
	return res;
}

int main(int argc,char **argv){
	if (argc!=3){
		puts("Argument Error");
		return 0;
	}
	FILE* fpred=fopen(argv[1],"r");
	FILE* ftruth=fopen(argv[2],"r");

	char s[1000000];
	double sum=0;
	int cnt=0;
	for (;fgets(s,1000000,fpred);){
		vector<int> pred=parseFeature(s);
		fgets(s,1000000,ftruth);
		vector<int> truth=parseFeature(s);
		set<int> spred;
		spred.clear();
		for (int i=0;i<pred.size();i++)
			spred.insert(pred[i]);
		int hit=0;
		for (int i=0;i<truth.size();i++)
			if (spred.find(truth[i])!=spred.end())
				hit++;
		double p=hit/(double)spred.size();
		double r=hit/(double)truth.size();
		if (hit>0) sum+=2*p*r/(p+r);
		//cout<<p<<' '<<r<<endl;
		cnt++;
	}
	cout<<sum/cnt<<endl;
	fclose(fpred);
	fclose(ftruth);
	return 0;
}