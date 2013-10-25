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

int N;
FILE* fin;
FILE* ftags;
map<string,int> dict;

char s[1000000];

int parseInstance(char *s){
	int len=strlen(s);
	for (int i=0;i<len;i++) if (s[i]=='\n'||s[i]=='\r') s[i]=' ';
	int id;
	if (sscanf(s,"\"%d\"",&id)!=1) return 0;
	char* sttitle=strstr(s,"\",\"")+3;
	char* entitle=strstr(sttitle,"\",\"");
	char* stbody=entitle+3;
	char* enbody=stbody;
	for (;;){
		char* t=strstr(enbody+3,"\",\"");
		if (t!=0) enbody=t;
		else break;
	}
	char* sttags=enbody+3;
	char* entags=strstr(sttags,"\"");
	if (entags!=0)
		entags[0]=0;
	for (char*p=strtok(sttags," ");p;p=strtok(NULL," "))
		if (strlen(p)>0){
			dict[p]++;
		}
	return 1;
}

void parse(){
	int cline=0,cdoc=0;
	int pos=0;
	char ts[1000000];
	fgets(ts,100000,fin);
	for (;;){
		if (!fgets(ts,1000000-pos,fin)) break;
		int id;
		if (pos!=0&&sscanf(ts,"\"%d\"",&id)==1){
			cdoc+=parseInstance(s);
			pos=strlen(ts);
			memcpy(s,ts,sizeof(char)*pos);
		}
		else{
			int len=strlen(ts);
			memcpy(s+pos,ts,sizeof(char)*(len+1));
			pos+=len;
		}
		cline++;
		if (cline%10000==0){
			fprintf(stderr,"\rParsing: #Line = %.2fM, #Document = %d",cline/1000000.,cdoc);
			fflush(stderr);
		}
	}
	cdoc+=parseInstance(s);
	fprintf(stderr,"\rParsing Finished: #Line = %.2fM, #Document = %d\n",cline/1000000.,cdoc);
	fflush(stderr);
}

int main(int argc,char** argv){
	if (argc!=3){
		printf("Argument Error, Usage\n");
		printf("InputFileName OutputFileName\n");
		return 0;
	}
	fin=fopen(argv[1],"r");
	ftags=fopen(argv[2],"w");
	dict.clear();
	parse();
	for (map<string,int>::iterator itr=dict.begin();itr!=dict.end();itr++)
		fprintf(ftags,"%s\t%d\n",itr->first.c_str(),itr->second);
	fclose(fin);
	fclose(ftags);
    return 0;
}

