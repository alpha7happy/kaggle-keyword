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

vector<pair<int,string> > dict;
vector<int> acc;
FILE* ftitle;
FILE* fbody;
FILE* ftags;
FILE* fout;
vector<pair<int,int> > title,body,tags;
char s[1000000];
int sum=0;

void loadDict(char* filename){
	FILE* fin=fopen(filename,"r");
	dict.clear();
	char s[10000];
	int cnt;
	for (;fscanf(fin,"%s%d",s,&cnt)==2;){
		dict.PB(MP(cnt,s));
		sum+=cnt;
		acc.PB(sum);
	}
	fclose(fin);
}

vector<pair<int,int> > parseFeature(char* s){
	vector<pair<int,int> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id,cnt;
		if (sscanf(p,"%d:%d",&id,&cnt)==2)
			res.PB(MP(id,cnt));
	}
	return res;
}

int getRandTag(){
	int t=rand()%sum;
	return lower_bound(acc.begin(),acc.end(),t)-acc.begin();
}

int main(int argc,char **argv){
	if (argc!=7){
		puts("Argument Error");
		return 0;
	}
	srand(time(0));
	loadDict(argv[1]);
	ftitle=fopen(argv[2],"r");
	fbody=fopen(argv[3],"r");
	ftags=fopen(argv[4],"r");
	fout=fopen(argv[5],"w");
	int N=atoi(argv[6]);
	int cnt=0;
	for (;fgets(s,1000000,ftags);){
		cnt++;
		if (cnt%10000==0){
			printf("\rCalculating, #doc = %.2fM",cnt/1000000.);
			fflush(stdout);
		}
		tags=parseFeature(s);
		set<int> cand;
		cand.clear();
		for (int i=0;i<tags.size();i++)
			cand.insert(tags[i].first);
		for (;(int)cand.size()<N;)
			cand.insert(getRandTag());
		for (set<int>::iterator itr=cand.begin();itr!=cand.end();itr++)
			fprintf(fout,"%d ",*itr);
		fprintf(fout,"\n");
	}
	printf("\rCalculating Finished, #doc= %.2fM\n",cnt/1000000.);
	fclose(ftitle);
	fclose(fbody);
	fclose(ftags);
	fclose(fout);
	return 0;
}