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

#include "parseDoc.h"

vector<pair<double,string> > split;
string InputFileName;
string HTMLTagsFileName;
string TagsFileName;
int N;
FILE* fin;
FILE** fid,**ftitle,**fbody,**ftags;
bool isTest;

bool loadConfig(int argc,char** argv){
	if (argc<4) return false;
	InputFileName=argv[1];
	HTMLTagsFileName=argv[2];
	TagsFileName=argv[3];
	parseDocInit(HTMLTagsFileName,TagsFileName);
	N=atoi(argv[4]);
	split.clear();
	if (argc!=5+2*N) return false;
	for (int i=0;i<N;i++){
		double r;
		sscanf(argv[5+i*2],"%lf",&r);
		split.PB(MP(r,argv[5+i*2+1]));
	}
	return true;
}

void initFiles(){
	fin=fopen(InputFileName.c_str(),"r");
	fid=new FILE*[N];
	ftitle=new FILE*[N];
	fbody=new FILE*[N];
	ftags=new FILE*[N];
	for (int i=0;i<N;i++){
		fid[i]=fopen((split[i].second+".Id").c_str(),"w");
		ftitle[i]=fopen((split[i].second+".Title").c_str(),"w");
		fbody[i]=fopen((split[i].second+".Body").c_str(),"w");
		ftags[i]=fopen((split[i].second+".Tags").c_str(),"w");
	}
}

void closeFiles(){
	fclose(fin);
	for (int i=0;i<N;i++){
		fclose(fid[i]);
		fclose(ftitle[i]);
		fclose(fbody[i]);
		fclose(ftags[i]);
	}
}

char s[1000000];

void parseHeader(){
	fgets(s,1000000,fin);
	int cnt=0;
	for (int i=0;i<strlen(s);i++)
		cnt+=(s[i]=='"');
	isTest=(cnt==6);
}

int getfid(){
	double x=rand()/(double)RAND_MAX;
	for (int i=0;i<N;i++){
		x-=split[i].first;
		if (x<=0) return i;
	}
	return -1;
}

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
	int tid=getfid();
	if (tid<0) return 1;
	entags[0]=0;
	fprintf(ftags[tid],"%s\n",parseDoc(sttags,true).c_str());
	enbody[0]=0;
	fprintf(fbody[tid],"%s\n",parseDoc(stbody).c_str());
	entitle[0]=0;
	fprintf(ftitle[tid], "%s\n",parseDoc(sttitle).c_str());
	fprintf(fid[tid],"%d\n",id);
	return 1;
}

void parse(){
	parseHeader();
	int cline=0,cdoc=0;
	int pos=0;
	char ts[1000000];
	for (;;){

		if (!fgets(ts,1000000-pos,fin)) break;
		int id;
		if (pos>100000){
			cout<<s<<endl;
			for(;;);
		}
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
	if (!loadConfig(argc,argv)){
		printf("Argument Error, Usage\n");
		printf("InputFileName N {Ratio_i OutputFileName_i}\n");
		return 0;
	}
	initFiles();
	srand(time(0));
	parse();
	closeFiles();
    return 0;
}

