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

vector<string> dict;

void loadDict(char* filename){
	FILE* fin=fopen(filename,"r");
	dict.clear();
	char s[10000];
	for (;fscanf(fin,"%s%*d",s)==1;)
		dict.PB(s);
	fclose(fin);
}

int main(int argc,char **argv){
	if (argc!=5){
		puts("Argument Error");
		return 0;
	}
	loadDict(argv[1]);
	FILE* fid=fopen(argv[2],"r");
	FILE* fin=fopen(argv[3],"r");
	FILE* fout=fopen(argv[4],"w");

	char s[1000000];
	int id;
	fprintf(fout,"\"Id\",\"Tags\"\n");
	for (;fscanf(fid,"%d",&id)==1;){
		fgets(s,1000000,fin);
		fprintf(fout,"%d,\"",id);
		bool st=true;
		for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
			st=false;
			int id;
			if (sscanf(p,"%d",&id)==1){
				if (!st) fprintf(fout," ");
				fprintf(fout,"%s",dict[id].c_str());
			}
		}
		fprintf(fout,"\"\n");
	}
	fclose(fid);
	fclose(fin);
	fclose(fout);
	return 0;
}