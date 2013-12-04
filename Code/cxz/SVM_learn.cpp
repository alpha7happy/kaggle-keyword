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
	if (argc!=5){
		puts("Argument Error");
		return 0;
	}
	FILE* ffeature=fopen(argv[1],"r");
	FILE* ftag=fopen(argv[2],"r");
	string svmdir=argv[3];
	Ntag=atoi(argv[4]);
	
	system(("mkdir "+svmdir).c_str());
	data.clear();
	tag.clear();
	int cnt=0;
	
	for (;fgets(s,1000000,ffeature);){
		cnt++;
		if (cnt%10000==0){
			printf("\rCalculating, #doc = %.2fM",cnt/1000000.);
			fflush(stdout);
		}
		data.PB(s);
		set<int> ttag;
		ttag.clear();
		fgets(s,1000000,ftag);
		vector<pair<int,int> > ptag=parseFeature(s);
		for (int i=0;i<ptag.size();i++)
			ttag.insert(ptag[i].first);
		tag.PB(ttag);
	}
	puts("Loading Finished            \n");
	for (int i=0;i<Ntag;i++){
		printf("\rRunning SVM on Tag %d",i);
		fflush(stdout);
		set<int> docs;
		docs.clear();
		for (int z=0;z<tag.size();z++)
			if (tag[z].find(i)!=tag[z].end())
				docs.insert(z);
		int nt=docs.size();
		for (;docs.size()<nt*2;){
			int z=rand()%tag.size();
			if (tag[z].find(i)==tag[z].end())
				docs.insert(z);
		}
		char filename[1000];
		sprintf(filename,"%s%d.data",svmdir.c_str(),i);
		FILE* fout=fopen(filename,"w");
		int cnt=0;
		for (set<int>::iterator itr=docs.begin();itr!=docs.end()&&cnt<100000000;itr++,cnt++)
			fprintf(fout,"%d %s",(tag[*itr].find(i)==tag[*itr].end()?-1:1),data[*itr].c_str());
		fclose(fout);
		char cmd[1000];
		sprintf(cmd,"Tools/libSVM/svm-scale -l 0 -u 1 -s %s%d.range %s%d.data > %s%d.data.scaled"
			,svmdir.c_str(),i,svmdir.c_str(),i,svmdir.c_str(),i);
		system(cmd);
		sprintf(cmd,"Tools/SVMlight/svm_learn -# 100000 %s%d.data.scaled %s%d.model > %s%d.log"
			,svmdir.c_str(),i,svmdir.c_str(),i,svmdir.c_str(),i);
		system(cmd);
		sprintf(cmd,"Tools/SVMlight/svm_classify %s%d.data.scaled %s%d.model tmp.pred > %s%d.trainlog"
			,svmdir.c_str(),i,svmdir.c_str(),i,svmdir.c_str(),i);
		system(cmd);
		/*sprintf(cmd,"Tools/SVMlight/svm_classify %s %s%d.model %s%d.predict > %s%d.predlog"
			,testdata.c_str(),svmdir.c_str(),i,svmdir.c_str(),i,svmdir.c_str(),i);
		system(cmd);
		sprintf(filename,"%s%d.predict",svmdir.c_str(),i);
		FILE* ftpred=fopen(filename,"r");
		double score;
		int z=0;
		for (;fscanf(ftpred,"%lf",&score)==1;z++){
			if (i==0){
				vector<pair<double,int> >tpred;
				tpred.clear();
				pred.PB(tpred);
			}
			pred[z].PB(MP(score,i));
		}
		fclose(ftpred);*/
	}
	printf("\rSVM Finished                     \n");
	/*for (int i=0;i<pred.size();i++){
		sort(pred[i].begin(),pred[i].end());
		reverse(pred[i].begin(),pred[i].end());
		for (int j=0;j<Ntag;j++)
			fprintf(fpred,"%d:%.5f ",pred[i][j].second,pred[i][j].first);
		fprintf(fpred,"\n");
	}
	fclose(fpred);
	puts("SVM Prediction Generated");*/
	return 0;
}