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

vector<string> data;
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

string toData(vector<pair<int,int> > data){
	string res="";
	char s[1000];
	for (int i=0;i<data.size();i++){
		sprintf(s,"%d:%d ",1+data[i].first,data[i].second);
		res=res+s;
	}
	return res;
}

char s[1000000];
int main(int argc,char** argv){
	if (argc!=4){
		puts("Argument Error");
		return 0;
	}
	FILE* ffeature=fopen(argv[1],"r");
	FILE* ftag=fopen(argv[2],"r");
	FILE* fout=fopen(argv[3],"w");
	
	data.clear();
	tag.clear();
	int cnt=0;
	
	for (;fgets(s,1000000,ffeature);){
		cnt++;
		if (cnt%10000==0){
			printf("\rCalculating, #doc = %.2fM",cnt/1000000.);
			fflush(stdout);
		}
		if (cnt==2000) break; 
		string data=s;
		set<int> ttag;
		ttag.clear();
		fgets(s,1000000,ftag);
		vector<pair<int,int> > ptag=parseFeature(s);
		for (int i=0;i<ptag.size();i++)
			fprintf(fout,"%d %s",ptag[i].first,data.c_str());
	}
	fclose(fout);
	return 0;
}