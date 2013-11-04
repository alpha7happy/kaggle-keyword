==========================
Folders & Files:
!!! Folders MUST be manually created !!!
/
    Code/
        cxz/
        zyb/
    Executable
        cxz/
        zyb/
    RawData/
        Train.csv
        Test.csv
    FullData/
        (Train|Test).(Id|Title|Body|Tags)
        Dictionary
        Dictionary.refined
    FullFeature/
        (Train|Test).(Id|Title|Body|Tags).BOW
        (Train|Test).candTags
    FullRun/
    ValData/
        (Train|Test).(Id|Title|Body|Tags)
        Dictionary
        Dictionary.refined
    ValFeature/
        (Train|Test).(Id|Title|Body|Tags).BOW
        (Train|Test).candTags
    ValRun/
    GlobalData/

==========================
Software requirement:
1. G++

2. Python 2.7.5
    http://www.python.org/download/releases/2.7.5/

3. Swig (The installation script of Scipy requires this..)
    Installation for OS X
        sudo brew install swig
    Other OS
        http://www.swig.org/download.html    

==========================
Usage:
sudo make install
    Install all dependencies

make Validation
    Generate validation data and feature files
