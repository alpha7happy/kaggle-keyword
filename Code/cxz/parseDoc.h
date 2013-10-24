set<char> pdignore;
set<string> pdlabel;
bool pdinit=false;

void parseDocInit(string HTMLTagFileName){
	pdinit=true;
	pdignore.clear();
	pdlabel.clear();
	FILE* fin=fopen(HTMLTagFileName.c_str(),"r");
	for (char s[1000];fscanf(fin,"%s",s)==1;)
		pdlabel.insert(s);
}

inline string identify(char* p){
	int len=strlen(p);
	if (len==0) return "";
	bool d=false;
	bool num=true;
	for (int i=0;i<len;i++)
		if (p[i]=='.') d=true;
		else if (!isdigit(p[i])) num=false;
	if (num)
		return d?"DOUBLE ":"INT ";
	return ((string)p)+" ";
}

inline string toLabel(string label){
	for (int i=0;i<label.size();i++)
		if (label[i]=='/') label[i]='E';
	else label[i]=label[i]-'a'+'A';
	return label+" ";
}
//set<string> pdtags;

char* parseDoc(char* s, bool istag=false){
	if (!pdinit){
		puts("parseDoc not initialized");
		return s;
	}
	int len=strlen(s);

	/*if (istag){
		for (char*p=strtok(s," ");p;p=strtok(NULL," ")){
			int tl=strlen(p);
			for (int i=0;i<tl;i++)
				if (!isalpha(p[i])&&!isdigit(p[i])&&p[i]!='-'&&p[i]!='.'&&p[i]!='+'&&p[i]!='#')
					if (pdtags.find(p)==pdtags.end()){
						cout<<p<<endl;
						pdtags.insert(p);
					}
		}
		return s;
	}*/
	for (int i=0;i<len;i++)
		if (s[i]>='A'&&s[i]<='Z') s[i]=s[i]-'A'+'a';
	for (int i=0;i<len;i++){
		if (isalpha(s[i])) s[i]=s[i];
		else if (s[i]=='/'){
			if (i==0||s[i-1]!='<')
				s[i]=' ';
		}
		else if ((s[i]>='0'&&s[i]<='9')
				||(s[i]=='-'||s[i]=='.'||s[i]=='+'||s[i]=='#')
				) s[i]=s[i];
		else if (s[i]=='<'){
			s[i]=' ';
			string label="";
			int z;
			for (z=1;z<20;z++)
				if (s[i+z]=='>') break;
				else label=label+s[i+z];
			if (z<20){
				s[i+z]=' ';
				string plabel;
				if (label[0]=='/') plabel=label.substr(1);
				else plabel=label;
				if (pdlabel.find(label)!=pdlabel.end()){
					for (int j=1;j<z;j++)
						if (s[i+j]=='/') s[i+j]='E';
					else if (s[i+j]>='a'&&s[i+j]<='z') s[i+j]=s[i+j]-'a'+'A';
					else s[i+j]='E';
				}
			}
		}
		else {
			//if (s[i]=='+'){for (int z=i-20;z<i+20;z++) printf("%c",s[z]);puts("");}
			if (pdignore.find(s[i])==pdignore.end()){
				//if (s[i]>0) printf("Ignore |%c| (%d)\n",s[i],(int)s[i]);
				pdignore.insert(s[i]);
			}
			s[i]=' ';
		}
	}
	string res="";
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int len=strlen(p);
		if (len==0) continue;
		res+=identify(p);
	}
	char* sres=new char[res.size()+20];
	sprintf(sres,"%s",res.c_str());
	return sres;
}